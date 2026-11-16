import 'package:poodle_server/src/modules/notebook/notebook_rag_primitives.dart';
import 'package:test/test.dart';

void main() {
  test('chunks preserve stable source locations and bounded overlap', () {
    final block = NotebookTextBlock(
      sourceVersionId: 'version-1',
      blockId: 'page-3-paragraph-2',
      location: const NotebookSourceLocation(page: 3, block: 'paragraph-2'),
      text: List.generate(12, (index) => 'word$index').join(' '),
    );

    final chunks = NotebookChunker(maxWords: 5, overlapWords: 2).chunk([block]);

    expect(chunks, hasLength(4));
    expect(chunks.map((chunk) => chunk.text), [
      'word0 word1 word2 word3 word4',
      'word3 word4 word5 word6 word7',
      'word6 word7 word8 word9 word10',
      'word9 word10 word11',
    ]);
    expect(chunks.every((chunk) => chunk.location.page == 3), isTrue);
    expect(chunks.map((chunk) => chunk.id).toSet(), hasLength(chunks.length));
  });

  test('reciprocal rank fusion combines vector and keyword rankings', () {
    final ranked = NotebookRankFusion.merge([
      [
        const NotebookRankedChunk(id: 'a', text: 'A'),
        const NotebookRankedChunk(id: 'b', text: 'B'),
      ],
      [
        const NotebookRankedChunk(id: 'b', text: 'B'),
        const NotebookRankedChunk(id: 'c', text: 'C'),
      ],
    ]);

    expect(ranked.map((chunk) => chunk.id), ['b', 'a', 'c']);
  });

  test('citation validation rejects IDs outside the retrieved source set', () {
    expect(
      () => NotebookCitationValidator.validate(
        citedChunkIds: ['chunk-1', 'invented'],
        retrievedChunkIds: {'chunk-1', 'chunk-2'},
      ),
      throwsFormatException,
    );
    expect(
      NotebookCitationValidator.validate(
        citedChunkIds: ['chunk-1', 'chunk-1', 'chunk-2'],
        retrievedChunkIds: {'chunk-1', 'chunk-2'},
      ),
      ['chunk-1', 'chunk-2'],
    );
  });
}
