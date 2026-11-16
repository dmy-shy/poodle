import 'package:serverpod/serverpod.dart';
import '../../core/account_authorization.dart';
import '../../generated/protocol.dart';
import 'notebook_execution_access.dart';
import 'notebook_history_service.dart';

class NotebookCitationService {
  /// Resolves only a citation actually attached to an accessible answer.
  /// Never accepts a source/version supplied by the client as authority.
  Future<String> passage(
    Session session,
    UuidValue notebookId,
    UuidValue turnId,
    UuidValue chunkId,
  ) async {
    final history = await NotebookHistoryService().turns(session, notebookId);
    final turn = history.where((t) => t.id == turnId).firstOrNull;
    final citation = turn?.citations
        .where((c) => c.chunkId == chunkId)
        .firstOrNull;
    if (turn == null || turn.stale || citation == null) {
      throw NotebookError(code: 'unavailable');
    }
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
      final version = access.versions[citation.sourceId];
      final chunk = await NotebookChunkRecord.db.findById(
        privateSession,
        chunkId,
      );
      if (version == null ||
          version.id != citation.sourceVersionId ||
          version.version != citation.sourceVersion ||
          chunk == null ||
          chunk.sourceId != citation.sourceId ||
          chunk.sourceVersionId != version.id) {
        throw NotebookError(code: 'unavailable');
      }
      return chunk.content;
    } finally {
      await privateSession.close();
    }
  }
}
