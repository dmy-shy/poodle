import 'package:serverpod/serverpod.dart';

import '../../core/account_authorization.dart';
import '../../generated/protocol.dart';
import 'notebook_execution_access.dart';
import 'notebook_history_service.dart';
import 'notebook_repository.dart';

class NotebookNoteService {
  NotebookNoteView _view(NotebookNoteRecord note, int revision) =>
      NotebookNoteView(
        id: note.id!,
        turnId: note.turnId,
        content: note.content,
        stale: note.sourceRevision != revision,
        createdAt: note.createdAt,
      );

  Future<NotebookNoteView> save(
    Session session,
    UuidValue notebookId,
    UuidValue turnId,
  ) async {
    final owner = (await AccountAuthorization.requireAccount(
      session,
    )).authUserId;
    final privateSession = await session.serverpod.createSession(
      enableLogging: false,
    );
    try {
      return await privateSession.db.transaction((tx) async {
        final repository = NotebookRepository();
        await repository.lock(privateSession, 'notebook:$notebookId', tx);
        final access = await NotebookExecutionAccess.require(
          privateSession,
          notebookId,
          owner,
          transaction: tx,
        );
        final existing = await NotebookNoteRecord.db.findFirstRow(
          privateSession,
          where: (t) =>
              t.notebookId.equals(notebookId) &
              t.ownerUserId.equals(owner) &
              t.turnId.equals(turnId),
          transaction: tx,
        );
        if (existing != null) return _view(existing, access.config.revision);
        final turn = (await NotebookHistoryService().turns(session, notebookId))
            .where(
              (t) =>
                  t.id == turnId &&
                  t.role == 'assistant' &&
                  !t.stale &&
                  t.content.isNotEmpty,
            )
            .firstOrNull;
        if (turn == null) throw NotebookError(code: 'unavailable');
        final note = await NotebookNoteRecord.db.insertRow(
          privateSession,
          NotebookNoteRecord(
            notebookId: notebookId,
            ownerUserId: owner,
            turnId: turnId,
            content: turn.content,
            sourceRevision: access.config.revision,
          ),
          transaction: tx,
        );
        return _view(note, access.config.revision);
      });
    } finally {
      await privateSession.close();
    }
  }

  Future<List<NotebookNoteView>> list(
    Session session,
    UuidValue notebookId,
  ) async {
    final owner = (await AccountAuthorization.requireAccount(
      session,
    )).authUserId;
    final access = await NotebookExecutionAccess.require(
      session,
      notebookId,
      owner,
    );
    final rows = await NotebookNoteRecord.db.find(
      session,
      where: (t) =>
          t.notebookId.equals(notebookId) & t.ownerUserId.equals(owner),
      orderBy: (t) => t.createdAt.desc(),
    );
    return rows.map((row) => _view(row, access.config.revision)).toList();
  }

  Future<void> delete(
    Session session,
    UuidValue notebookId,
    UuidValue noteId,
  ) async {
    final owner = (await AccountAuthorization.requireAccount(
      session,
    )).authUserId;
    await NotebookExecutionAccess.require(session, notebookId, owner);
    await NotebookNoteRecord.db.deleteWhere(
      session,
      where: (t) =>
          t.id.equals(noteId) &
          t.notebookId.equals(notebookId) &
          t.ownerUserId.equals(owner),
    );
  }
}
