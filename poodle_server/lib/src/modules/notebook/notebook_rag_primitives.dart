import 'package:crypto/crypto.dart';
import 'dart:convert';

class NotebookSourceLocation {
  const NotebookSourceLocation({this.page, this.block});

  final int? page;
  final String? block;
}

class NotebookTextBlock {
  const NotebookTextBlock({
    required this.sourceVersionId,
    required this.blockId,
    required this.location,
    required this.text,
  });

  final String sourceVersionId;
  final String blockId;
  final NotebookSourceLocation location;
  final String text;
}

class NotebookTextChunk {
  const NotebookTextChunk({
    required this.id,
    required this.sourceVersionId,
    required this.blockId,
    required this.location,
    required this.text,
  });

  final String id;
  final String sourceVersionId;
  final String blockId;
  final NotebookSourceLocation location;
  final String text;
}

/// Splits normalized source blocks by words while retaining their locations.
/// The word limit is a deterministic approximation until provider tokenizers
/// are introduced into ingestion.
class NotebookChunker {
  const NotebookChunker({this.maxWords = 512, this.overlapWords = 64})
    : assert(maxWords > 0),
      assert(overlapWords >= 0),
      assert(overlapWords < maxWords);

  final int maxWords;
  final int overlapWords;

  List<NotebookTextChunk> chunk(Iterable<NotebookTextBlock> blocks) {
    final result = <NotebookTextChunk>[];
    for (final block in blocks) {
      final words = block.text.trim().split(RegExp(r'\s+'));
      if (words.length == 1 && words.single.isEmpty) continue;
      final step = maxWords - overlapWords;
      for (var start = 0; start < words.length; start += step) {
        final text = words.skip(start).take(maxWords).join(' ');
        final identity = [
          block.sourceVersionId,
          block.blockId,
          start.toString(),
          text,
        ].join('\u0000');
        result.add(
          NotebookTextChunk(
            id: sha256.convert(utf8.encode(identity)).toString(),
            sourceVersionId: block.sourceVersionId,
            blockId: block.blockId,
            location: block.location,
            text: text,
          ),
        );
        if (start + maxWords >= words.length) break;
      }
    }
    return List.unmodifiable(result);
  }
}

class NotebookRankedChunk {
  const NotebookRankedChunk({required this.id, required this.text});

  final String id;
  final String text;
}

/// Reciprocal rank fusion for combining vector and lexical result lists.
abstract final class NotebookRankFusion {
  static List<NotebookRankedChunk> merge(
    Iterable<List<NotebookRankedChunk>> rankings, {
    int constant = 60,
  }) {
    if (constant <= 0) throw ArgumentError.value(constant, 'constant');
    final scores = <String, double>{};
    final chunks = <String, NotebookRankedChunk>{};
    for (final ranking in rankings) {
      for (var index = 0; index < ranking.length; index++) {
        final chunk = ranking[index];
        if (chunk.id.isEmpty) continue;
        scores.update(
          chunk.id,
          (score) => score + 1 / (constant + index + 1),
          ifAbsent: () => 1 / (constant + index + 1),
        );
        chunks.putIfAbsent(chunk.id, () => chunk);
      }
    }
    final ids = scores.keys.toList()
      ..sort((a, b) {
        final score = scores[b]!.compareTo(scores[a]!);
        return score != 0 ? score : a.compareTo(b);
      });
    return List.unmodifiable(ids.map((id) => chunks[id]!));
  }
}

abstract final class NotebookCitationValidator {
  static List<String> validate({
    required Iterable<String> citedChunkIds,
    required Set<String> retrievedChunkIds,
  }) {
    final result = <String>[];
    final seen = <String>{};
    for (final id in citedChunkIds) {
      if (!retrievedChunkIds.contains(id)) {
        throw FormatException('Citation is outside the retrieved source set.');
      }
      if (seen.add(id)) result.add(id);
    }
    return List.unmodifiable(result);
  }
}
