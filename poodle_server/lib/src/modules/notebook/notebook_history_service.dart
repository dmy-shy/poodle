import 'dart:convert';
import 'package:serverpod/serverpod.dart';
import '../../core/account_authorization.dart';
import '../../generated/protocol.dart';
import 'notebook_execution_access.dart';

class NotebookHistoryService {
  Future<List<NotebookTurnView>> turns(
    Session session,
    UuidValue notebookId,
  ) async {
    final owner = await AccountAuthorization.requireAccount(session);
    final privateSession = await session.serverpod.createSession(
      enableLogging: false,
    );
    try {
      final access = await NotebookExecutionAccess.require(
        privateSession,
        notebookId,
        owner.authUserId,
      );
      final rows = await NotebookTurnRecord.db.find(
        privateSession,
        where: (t) =>
            t.notebookId.equals(notebookId) &
            t.ownerUserId.equals(owner.authUserId),
        orderBy: (t) => t.turnIndex.desc(),
        limit: 50,
      );
      final result = <NotebookTurnView>[];
      for (final row in rows.reversed) {
        var stale =
            row.role == 'assistant' &&
            row.sourceRevision != access.config.revision;
        var citations = <NotebookCitation>[];
        if (row.role == 'assistant') {
          try {
            final decoded = jsonDecode(row.citationsJson) as List;
            citations = decoded
                .map(
                  (v) => NotebookCitation.fromJson(
                    Map<String, dynamic>.from(v as Map),
                  ),
                )
                .toList();
            if (!row.insufficientEvidence && citations.isEmpty) stale = true;
            for (final citation in citations) {
              final version = access.versions[citation.sourceId];
              final chunk = await NotebookChunkRecord.db.findById(
                privateSession,
                citation.chunkId,
              );
              if (version == null ||
                  version.id != citation.sourceVersionId ||
                  version.version != citation.sourceVersion ||
                  chunk?.sourceVersionId != version.id ||
                  chunk?.sourceId != citation.sourceId) {
                stale = true;
              }
            }
          } catch (_) {
            stale = true;
          }
        }
        result.add(
          NotebookTurnView(
            id: row.id!,
            role: row.role,
            content: stale ? '' : row.content,
            citations: stale ? const [] : citations,
            insufficientEvidence: row.insufficientEvidence,
            stale: stale,
            createdAt: row.createdAt,
          ),
        );
      }
      return result;
    } finally {
      await privateSession.close();
    }
  }
}
