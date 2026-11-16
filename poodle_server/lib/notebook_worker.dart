/// Server-owned contracts shared with the trusted ingestion process.
library;

export 'src/generated/protocol.dart'
    show
        CourseRecord,
        CourseSectionRecord,
        CourseActivityRecord,
        CourseFileInfo,
        NotebookJobRecord,
        NotebookSourceRecord,
        NotebookChunkRecord,
        NotebookSourceVersionRecord,
        NotebookUsageMonthRecord;
export 'src/generated/protocol.dart'
    show
        NotebookRecord,
        NotebookAssessmentConfigRecord,
        NotebookAssessmentMaterialRecord,
        NotebookSourceSelectionRecord,
        NotebookTurnRecord,
        NotebookArtifactRecord,
        NotebookCitation,
        NotebookError;
export 'src/modules/notebook/notebook_execution_access.dart';
export 'src/modules/notebook/notebook_repository.dart';
export 'src/modules/notebook/notebook_ai_provider.dart';
export 'src/modules/notebook/notebook_policy.dart';
export 'src/modules/notebook/notebook_rag_primitives.dart';

export 'package:serverpod_auth_idp_server/core.dart' show AuthUser;
