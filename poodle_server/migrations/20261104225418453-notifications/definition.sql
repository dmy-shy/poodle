BEGIN;

--
-- CREATE VECTOR EXTENSION IF AVAILABLE
--
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_available_extensions WHERE name = 'vector') THEN
    EXECUTE 'CREATE EXTENSION IF NOT EXISTS vector';
  ELSE
    RAISE EXCEPTION 'Required extension "vector" is not available on this instance. Please install pgvector. For instructions, see https://docs.serverpod.dev/upgrading/upgrade-to-pgvector.';
  END IF;
END
$$;

--
-- Function: gen_random_uuid_v7()
-- Source: https://gist.github.com/kjmph/5bd772b2c2df145aa645b837da7eca74
-- License: MIT (copyright notice included on the generator source code).
--
create or replace function gen_random_uuid_v7()
returns uuid
as $$
begin
  -- use random v4 uuid as starting point (which has the same variant we need)
  -- then overlay timestamp
  -- then set version 7 by flipping the 2 and 1 bit in the version 4 string
  return encode(
    set_bit(
      set_bit(
        overlay(uuid_send(gen_random_uuid())
                placing substring(int8send(floor(extract(epoch from clock_timestamp()) * 1000)::bigint) from 3)
                from 1 for 6
        ),
        52, 1
      ),
      53, 1
    ),
    'hex')::uuid;
end
$$
language plpgsql
volatile;

--
-- Class AccountAccess as table poodle_account_access
--
CREATE TABLE "poodle_account_access" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "isAdmin" boolean NOT NULL DEFAULT false,
    "teacherApproved" boolean NOT NULL DEFAULT false,
    "developmentBootstrap" boolean NOT NULL DEFAULT false,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "poodle_account_access_user_unique" ON "poodle_account_access" USING btree ("authUserId");

--
-- Class AccountInvitation as table poodle_account_invitation
--
CREATE TABLE "poodle_account_invitation" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "email" text NOT NULL,
    "purpose" text NOT NULL,
    "issuerId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "expiresAt" timestamp without time zone NOT NULL,
    "acceptedAt" timestamp without time zone,
    "acceptedById" uuid,
    "revokedAt" timestamp without time zone
);

-- Indexes
CREATE INDEX "poodle_account_invitation_email" ON "poodle_account_invitation" USING btree ("email");
CREATE INDEX "poodle_account_invitation_created" ON "poodle_account_invitation" USING btree ("createdAt");

--
-- Class CourseRecord as table poodle_course
--
CREATE TABLE "poodle_course" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "title" text NOT NULL,
    "category" text,
    "summary" text,
    "teacherName" text,
    "seedOwned" boolean NOT NULL DEFAULT false
);

--
-- Class CourseActivityRecord as table poodle_course_activity
--
CREATE TABLE "poodle_course_activity" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "sectionId" uuid NOT NULL,
    "title" text NOT NULL,
    "description" text,
    "kind" text NOT NULL,
    "sortOrder" bigint NOT NULL,
    "published" boolean NOT NULL DEFAULT false,
    "file" json,
    "storageId" text,
    "storagePath" text,
    "link" json,
    "announcement" json,
    "assessment" json
);

-- Indexes
CREATE INDEX "poodle_activity_order" ON "poodle_course_activity" USING btree ("sectionId", "sortOrder");

--
-- Class CourseMembership as table poodle_course_membership
--
CREATE TABLE "poodle_course_membership" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "courseId" uuid NOT NULL,
    "authUserId" uuid NOT NULL,
    "role" text NOT NULL,
    "active" boolean NOT NULL DEFAULT true
);

-- Indexes
CREATE UNIQUE INDEX "poodle_membership_unique" ON "poodle_course_membership" USING btree ("courseId", "authUserId");

--
-- Class CourseSectionRecord as table poodle_course_section
--
CREATE TABLE "poodle_course_section" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "courseId" uuid NOT NULL,
    "title" text NOT NULL,
    "description" text,
    "sortOrder" bigint NOT NULL,
    "published" boolean NOT NULL DEFAULT false
);

-- Indexes
CREATE INDEX "poodle_section_order" ON "poodle_course_section" USING btree ("courseId", "sortOrder");

--
-- Class NotebookRecord as table poodle_notebook
--
CREATE TABLE "poodle_notebook" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "courseId" uuid NOT NULL,
    "assessmentActivityId" uuid NOT NULL,
    "ownerUserId" uuid NOT NULL,
    "configRevision" bigint NOT NULL DEFAULT 0,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "poodle_notebook_owner_assessment" ON "poodle_notebook" USING btree ("ownerUserId", "assessmentActivityId");
CREATE INDEX "poodle_notebook_course" ON "poodle_notebook" USING btree ("courseId");

--
-- Class NotebookArtifactRecord as table poodle_notebook_artifact
--
CREATE TABLE "poodle_notebook_artifact" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "notebookId" uuid NOT NULL,
    "ownerUserId" uuid NOT NULL,
    "kind" text NOT NULL,
    "title" text NOT NULL,
    "contentJson" text NOT NULL,
    "sourceRevision" bigint NOT NULL,
    "stale" boolean NOT NULL DEFAULT false,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "poodle_notebook_artifact_list" ON "poodle_notebook_artifact" USING btree ("notebookId", "createdAt");

--
-- Class NotebookAssessmentConfigRecord as table poodle_notebook_assessment_config
--
CREATE TABLE "poodle_notebook_assessment_config" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "courseId" uuid NOT NULL,
    "assessmentActivityId" uuid NOT NULL,
    "teacherUserId" uuid NOT NULL,
    "revision" bigint NOT NULL DEFAULT 1,
    "allowedFormats" json NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "poodle_notebook_config_assessment" ON "poodle_notebook_assessment_config" USING btree ("assessmentActivityId");
CREATE INDEX "poodle_notebook_config_course" ON "poodle_notebook_assessment_config" USING btree ("courseId");

--
-- Class NotebookAssessmentMaterialRecord as table poodle_notebook_assessment_material
--
CREATE TABLE "poodle_notebook_assessment_material" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "configId" uuid NOT NULL,
    "activityId" uuid NOT NULL,
    "sortOrder" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "poodle_notebook_material_unique" ON "poodle_notebook_assessment_material" USING btree ("configId", "activityId");

--
-- Class NotebookChunkRecord as table poodle_notebook_chunk
--
CREATE TABLE "poodle_notebook_chunk" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "sourceId" uuid NOT NULL,
    "sourceVersionId" uuid NOT NULL,
    "blockId" text NOT NULL,
    "pageNumber" bigint,
    "locationLabel" text,
    "content" text NOT NULL,
    "embedding" vector(1536) NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "poodle_notebook_chunk_version" ON "poodle_notebook_chunk" USING btree ("sourceVersionId");
CREATE INDEX "poodle_notebook_chunk_source" ON "poodle_notebook_chunk" USING btree ("sourceId");

--
-- Class NotebookJobRecord as table poodle_notebook_job
--
CREATE TABLE "poodle_notebook_job" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "ownerUserId" uuid NOT NULL,
    "notebookId" uuid,
    "sourceId" uuid,
    "jobType" text NOT NULL,
    "status" text NOT NULL DEFAULT 'queued'::text,
    "attempts" bigint NOT NULL DEFAULT 0,
    "leaseToken" text,
    "leaseExpiresAt" timestamp without time zone,
    "requestKey" text NOT NULL,
    "privatePayload" text,
    "failureCode" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "poodle_notebook_job_request" ON "poodle_notebook_job" USING btree ("ownerUserId", "requestKey");
CREATE INDEX "poodle_notebook_job_queue" ON "poodle_notebook_job" USING btree ("status", "createdAt");

--
-- Class NotebookSourceRecord as table poodle_notebook_source
--
CREATE TABLE "poodle_notebook_source" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "courseId" uuid NOT NULL,
    "notebookId" uuid,
    "ownerUserId" uuid,
    "activityId" uuid,
    "fileName" text NOT NULL,
    "format" text NOT NULL,
    "storageId" text NOT NULL,
    "storagePath" text NOT NULL,
    "status" text NOT NULL DEFAULT 'queued'::text,
    "currentVersion" bigint NOT NULL DEFAULT 0,
    "failureCode" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "poodle_notebook_source_activity" ON "poodle_notebook_source" USING btree ("activityId");
CREATE INDEX "poodle_notebook_source_owner" ON "poodle_notebook_source" USING btree ("ownerUserId", "courseId");
CREATE INDEX "poodle_notebook_source_status" ON "poodle_notebook_source" USING btree ("status");

--
-- Class NotebookSourceSelectionRecord as table poodle_notebook_source_selection
--
CREATE TABLE "poodle_notebook_source_selection" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "notebookId" uuid NOT NULL,
    "sourceId" uuid NOT NULL,
    "selected" boolean NOT NULL DEFAULT true,
    "selectedVersion" bigint NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "poodle_notebook_selection_unique" ON "poodle_notebook_source_selection" USING btree ("notebookId", "sourceId");
CREATE INDEX "poodle_notebook_selection_lookup" ON "poodle_notebook_source_selection" USING btree ("notebookId", "selected");

--
-- Class NotebookSourceVersionRecord as table poodle_notebook_source_version
--
CREATE TABLE "poodle_notebook_source_version" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "sourceId" uuid NOT NULL,
    "version" bigint NOT NULL,
    "checksum" text NOT NULL,
    "title" text NOT NULL,
    "extractedText" text NOT NULL,
    "status" text NOT NULL,
    "embeddingSpace" text NOT NULL DEFAULT 'legacy-unidentified'::text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "poodle_notebook_version_unique" ON "poodle_notebook_source_version" USING btree ("sourceId", "version");
CREATE INDEX "poodle_notebook_version_checksum" ON "poodle_notebook_source_version" USING btree ("checksum");

--
-- Class NotebookTurnRecord as table poodle_notebook_turn
--
CREATE TABLE "poodle_notebook_turn" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "notebookId" uuid NOT NULL,
    "ownerUserId" uuid NOT NULL,
    "requestKey" text NOT NULL,
    "turnIndex" bigint NOT NULL,
    "role" text NOT NULL,
    "content" text NOT NULL,
    "citationsJson" text NOT NULL DEFAULT '[]'::text,
    "insufficientEvidence" boolean NOT NULL DEFAULT false,
    "sourceRevision" bigint NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "poodle_notebook_turn_order" ON "poodle_notebook_turn" USING btree ("notebookId", "turnIndex");
CREATE UNIQUE INDEX "poodle_notebook_turn_request" ON "poodle_notebook_turn" USING btree ("ownerUserId", "requestKey");

--
-- Class NotebookUsageMonthRecord as table poodle_notebook_usage_month
--
CREATE TABLE "poodle_notebook_usage_month" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "monthUtc" timestamp without time zone NOT NULL,
    "spentMicros" bigint NOT NULL DEFAULT 0,
    "reservedMicros" bigint NOT NULL DEFAULT 0,
    "capMicros" bigint NOT NULL DEFAULT 10000000,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "poodle_notebook_usage_month_unique" ON "poodle_notebook_usage_month" USING btree ("monthUtc");

--
-- Class NotificationRecord as table poodle_notification
--
CREATE TABLE "poodle_notification" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "recipientId" uuid NOT NULL,
    "eventKey" text NOT NULL,
    "category" text NOT NULL,
    "courseId" uuid,
    "activityId" uuid,
    "title" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "readAt" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "poodle_notification_event_unique" ON "poodle_notification" USING btree ("recipientId", "eventKey");
CREATE INDEX "poodle_notification_recipient_time" ON "poodle_notification" USING btree ("recipientId", "createdAt");

--
-- Class TeacherDefaultsRecord as table poodle_teacher_defaults
--
CREATE TABLE "poodle_teacher_defaults" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "ownerId" uuid NOT NULL,
    "settings" json NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "poodle_teacher_defaults_unique" ON "poodle_teacher_defaults" USING btree ("ownerId");

--
-- Class TeachingActivityRecord as table poodle_teaching_activity
--
CREATE TABLE "poodle_teaching_activity" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "courseId" uuid NOT NULL,
    "activityId" uuid NOT NULL,
    "kind" text NOT NULL,
    "revision" bigint NOT NULL DEFAULT 1,
    "published" boolean NOT NULL DEFAULT false,
    "released" boolean NOT NULL DEFAULT false,
    "settings" json NOT NULL,
    "questions" json NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "poodle_teaching_activity_unique" ON "poodle_teaching_activity" USING btree ("activityId");

--
-- Class TeachingAttemptRecord as table poodle_teaching_attempt
--
CREATE TABLE "poodle_teaching_attempt" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "activityId" uuid NOT NULL,
    "ownerId" uuid NOT NULL,
    "versionId" uuid NOT NULL,
    "questions" json NOT NULL,
    "answers" json NOT NULL,
    "startedAt" timestamp without time zone NOT NULL,
    "expiresAt" timestamp without time zone NOT NULL,
    "submittedAt" timestamp without time zone,
    "score" double precision,
    "maxPoints" double precision NOT NULL
);

--
-- Class TeachingSubmissionRecord as table poodle_teaching_submission
--
CREATE TABLE "poodle_teaching_submission" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "activityId" uuid NOT NULL,
    "ownerId" uuid NOT NULL,
    "requestKey" text NOT NULL,
    "text" text NOT NULL,
    "uploadId" uuid,
    "submittedAt" timestamp without time zone NOT NULL,
    "reopenUntil" timestamp without time zone,
    "grade" double precision,
    "feedback" text NOT NULL DEFAULT ''::text,
    "gradedBy" uuid,
    "published" boolean NOT NULL DEFAULT false
);

-- Indexes
CREATE UNIQUE INDEX "poodle_teaching_submission_unique" ON "poodle_teaching_submission" USING btree ("ownerId", "requestKey");

--
-- Class TeachingUploadRecord as table poodle_teaching_upload
--
CREATE TABLE "poodle_teaching_upload" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "activityId" uuid NOT NULL,
    "ownerId" uuid NOT NULL,
    "fileName" text NOT NULL,
    "sizeBytes" bigint NOT NULL,
    "path" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- Class TeachingVersionRecord as table poodle_teaching_version
--
CREATE TABLE "poodle_teaching_version" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "activityId" uuid NOT NULL,
    "revision" bigint NOT NULL,
    "settings" json NOT NULL,
    "questions" json NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "poodle_teaching_version_unique" ON "poodle_teaching_version" USING btree ("activityId", "revision");

--
-- Class CloudStorageEntry as table serverpod_cloud_storage
--
CREATE TABLE "serverpod_cloud_storage" (
    "id" bigserial PRIMARY KEY,
    "storageId" text NOT NULL,
    "path" text NOT NULL,
    "addedTime" timestamp without time zone NOT NULL,
    "expiration" timestamp without time zone,
    "byteData" bytea NOT NULL,
    "verified" boolean NOT NULL,
    "contentType" text,
    "cacheControl" text,
    "contentDisposition" text,
    "contentEncoding" text,
    "customMetadata" text
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_cloud_storage_path_idx" ON "serverpod_cloud_storage" USING btree ("storageId", "path");
CREATE INDEX "serverpod_cloud_storage_expiration" ON "serverpod_cloud_storage" USING btree ("expiration");

--
-- Class CloudStorageDirectDownloadEntry as table serverpod_cloud_storage_direct_download
--
CREATE TABLE "serverpod_cloud_storage_direct_download" (
    "id" bigserial PRIMARY KEY,
    "storageId" text NOT NULL,
    "path" text NOT NULL,
    "expiration" timestamp without time zone NOT NULL,
    "authKey" text NOT NULL,
    "downloadFileName" text,
    "contentType" text
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_cloud_storage_direct_download_auth_key" ON "serverpod_cloud_storage_direct_download" USING btree ("authKey");
CREATE INDEX "serverpod_cloud_storage_direct_download_expiration" ON "serverpod_cloud_storage_direct_download" USING btree ("expiration");

--
-- Class CloudStorageDirectUploadEntry as table serverpod_cloud_storage_direct_upload
--
CREATE TABLE "serverpod_cloud_storage_direct_upload" (
    "id" bigserial PRIMARY KEY,
    "storageId" text NOT NULL,
    "path" text NOT NULL,
    "expiration" timestamp without time zone NOT NULL,
    "authKey" text NOT NULL,
    "maxFileSize" bigint NOT NULL DEFAULT 10485760,
    "contentLength" bigint,
    "preventOverwrite" boolean NOT NULL DEFAULT false,
    "contentType" text,
    "cacheControl" text,
    "contentDisposition" text,
    "contentEncoding" text,
    "customMetadata" text
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_cloud_storage_direct_upload_storage_path" ON "serverpod_cloud_storage_direct_upload" USING btree ("storageId", "path");

--
-- Class FutureCallEntry as table serverpod_future_call
--
CREATE TABLE "serverpod_future_call" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "serializedObject" text,
    "serverId" text NOT NULL,
    "identifier" text,
    "scheduling" json
);

-- Indexes
CREATE INDEX "serverpod_future_call_time_idx" ON "serverpod_future_call" USING btree ("time");
CREATE INDEX "serverpod_future_call_serverId_idx" ON "serverpod_future_call" USING btree ("serverId");
CREATE INDEX "serverpod_future_call_identifier_idx" ON "serverpod_future_call" USING btree ("identifier");

--
-- Class FutureCallClaimEntry as table serverpod_future_call_claim
--
CREATE TABLE "serverpod_future_call_claim" (
    "id" bigserial PRIMARY KEY,
    "futureCallId" bigint,
    "lastHeartbeatTime" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "future_call_unique_idx" ON "serverpod_future_call_claim" USING btree ("futureCallId");

--
-- Class ServerHealthConnectionInfo as table serverpod_health_connection_info
--
CREATE TABLE "serverpod_health_connection_info" (
    "id" bigserial PRIMARY KEY,
    "serverId" text NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    "active" bigint NOT NULL,
    "closing" bigint NOT NULL,
    "idle" bigint NOT NULL,
    "granularity" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_health_connection_info_timestamp_idx" ON "serverpod_health_connection_info" USING btree ("timestamp", "serverId", "granularity");

--
-- Class ServerHealthMetric as table serverpod_health_metric
--
CREATE TABLE "serverpod_health_metric" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "serverId" text NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    "isHealthy" boolean NOT NULL,
    "value" double precision NOT NULL,
    "granularity" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_health_metric_timestamp_idx" ON "serverpod_health_metric" USING btree ("timestamp", "serverId", "name", "granularity");

--
-- Class LogEntry as table serverpod_log
--
CREATE TABLE "serverpod_log" (
    "id" bigserial PRIMARY KEY,
    "sessionLogId" bigint NOT NULL,
    "messageId" bigint,
    "reference" text,
    "serverId" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "logLevel" bigint NOT NULL,
    "message" text NOT NULL,
    "error" text,
    "stackTrace" text,
    "order" bigint NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_log_sessionLogId_idx" ON "serverpod_log" USING btree ("sessionLogId", "order");

--
-- Class MessageLogEntry as table serverpod_message_log
--
CREATE TABLE "serverpod_message_log" (
    "id" bigserial PRIMARY KEY,
    "sessionLogId" bigint NOT NULL,
    "serverId" text NOT NULL,
    "messageId" bigint NOT NULL,
    "endpoint" text NOT NULL,
    "messageName" text NOT NULL,
    "duration" double precision NOT NULL,
    "error" text,
    "stackTrace" text,
    "slow" boolean NOT NULL,
    "order" bigint NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_message_log_sessionLogId_idx" ON "serverpod_message_log" USING btree ("sessionLogId", "order");

--
-- Class MethodInfo as table serverpod_method
--
CREATE TABLE "serverpod_method" (
    "id" bigserial PRIMARY KEY,
    "endpoint" text NOT NULL,
    "method" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_method_endpoint_method_idx" ON "serverpod_method" USING btree ("endpoint", "method");

--
-- Class DatabaseMigrationVersion as table serverpod_migrations
--
CREATE TABLE "serverpod_migrations" (
    "id" bigserial PRIMARY KEY,
    "module" text NOT NULL,
    "version" text NOT NULL,
    "timestamp" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_migrations_ids" ON "serverpod_migrations" USING btree ("module");

--
-- Class QueryLogEntry as table serverpod_query_log
--
CREATE TABLE "serverpod_query_log" (
    "id" bigserial PRIMARY KEY,
    "serverId" text NOT NULL,
    "sessionLogId" bigint NOT NULL,
    "messageId" bigint,
    "query" text NOT NULL,
    "duration" double precision NOT NULL,
    "numRows" bigint,
    "error" text,
    "stackTrace" text,
    "slow" boolean NOT NULL,
    "order" bigint NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_query_log_sessionLogId_idx" ON "serverpod_query_log" USING btree ("sessionLogId", "order");

--
-- Class ReadWriteTestEntry as table serverpod_readwrite_test
--
CREATE TABLE "serverpod_readwrite_test" (
    "id" bigserial PRIMARY KEY,
    "number" bigint NOT NULL
);

--
-- Class RuntimeSettings as table serverpod_runtime_settings
--
CREATE TABLE "serverpod_runtime_settings" (
    "id" bigserial PRIMARY KEY,
    "logSettings" json NOT NULL,
    "logSettingsOverrides" json NOT NULL,
    "logServiceCalls" boolean NOT NULL,
    "logMalformedCalls" boolean NOT NULL
);

--
-- Class SessionLogEntry as table serverpod_session_log
--
CREATE TABLE "serverpod_session_log" (
    "id" bigserial PRIMARY KEY,
    "serverId" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "module" text,
    "endpoint" text,
    "method" text,
    "duration" double precision,
    "numQueries" bigint,
    "slow" boolean,
    "error" text,
    "stackTrace" text,
    "authenticatedUserId" bigint,
    "userId" text,
    "isOpen" boolean,
    "touched" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_session_log_serverid_idx" ON "serverpod_session_log" USING btree ("serverId");
CREATE INDEX "serverpod_session_log_time_idx" ON "serverpod_session_log" USING btree ("time");
CREATE INDEX "serverpod_session_log_touched_idx" ON "serverpod_session_log" USING btree ("touched");
CREATE INDEX "serverpod_session_log_isopen_idx" ON "serverpod_session_log" USING btree ("isOpen");

--
-- Class AnonymousAccount as table serverpod_auth_idp_anonymous_account
--
CREATE TABLE "serverpod_auth_idp_anonymous_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- Class AppleAccount as table serverpod_auth_idp_apple_account
--
CREATE TABLE "serverpod_auth_idp_apple_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "userIdentifier" text NOT NULL,
    "refreshToken" text NOT NULL,
    "refreshTokenRequestedWithBundleIdentifier" boolean NOT NULL,
    "lastRefreshedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "authUserId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "email" text,
    "isEmailVerified" boolean,
    "isPrivateEmail" boolean,
    "firstName" text,
    "lastName" text
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_apple_account_identifier" ON "serverpod_auth_idp_apple_account" USING btree ("userIdentifier");

--
-- Class EmailAccount as table serverpod_auth_idp_email_account
--
CREATE TABLE "serverpod_auth_idp_email_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "email" text NOT NULL,
    "passwordHash" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_idp_email_account_email" ON "serverpod_auth_idp_email_account" USING btree ("email");

--
-- Class EmailAccountPasswordResetRequest as table serverpod_auth_idp_email_account_password_reset_request
--
CREATE TABLE "serverpod_auth_idp_email_account_password_reset_request" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "emailAccountId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "challengeId" uuid NOT NULL,
    "setPasswordChallengeId" uuid
);

--
-- Class EmailAccountRequest as table serverpod_auth_idp_email_account_request
--
CREATE TABLE "serverpod_auth_idp_email_account_request" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "email" text NOT NULL,
    "challengeId" uuid NOT NULL,
    "createAccountChallengeId" uuid
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_idp_email_account_request_email" ON "serverpod_auth_idp_email_account_request" USING btree ("email");

--
-- Class FacebookAccount as table serverpod_auth_idp_facebook_account
--
CREATE TABLE "serverpod_auth_idp_facebook_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "userIdentifier" text NOT NULL,
    "email" text,
    "fullName" text,
    "firstName" text,
    "lastName" text
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_facebook_account_user_identifier" ON "serverpod_auth_idp_facebook_account" USING btree ("userIdentifier");

--
-- Class FirebaseAccount as table serverpod_auth_idp_firebase_account
--
CREATE TABLE "serverpod_auth_idp_firebase_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "created" timestamp without time zone NOT NULL,
    "email" text,
    "phone" text,
    "userIdentifier" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_firebase_account_user_identifier" ON "serverpod_auth_idp_firebase_account" USING btree ("userIdentifier");

--
-- Class GitHubAccount as table serverpod_auth_idp_github_account
--
CREATE TABLE "serverpod_auth_idp_github_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "userIdentifier" text NOT NULL,
    "email" text,
    "created" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_github_account_user_identifier" ON "serverpod_auth_idp_github_account" USING btree ("userIdentifier");

--
-- Class GoogleAccount as table serverpod_auth_idp_google_account
--
CREATE TABLE "serverpod_auth_idp_google_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "created" timestamp without time zone NOT NULL,
    "email" text NOT NULL,
    "userIdentifier" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_google_account_user_identifier" ON "serverpod_auth_idp_google_account" USING btree ("userIdentifier");

--
-- Class MicrosoftAccount as table serverpod_auth_idp_microsoft_account
--
CREATE TABLE "serverpod_auth_idp_microsoft_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "userIdentifier" text NOT NULL,
    "email" text,
    "created" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_microsoft_account_user_identifier" ON "serverpod_auth_idp_microsoft_account" USING btree ("userIdentifier");

--
-- Class PasskeyAccount as table serverpod_auth_idp_passkey_account
--
CREATE TABLE "serverpod_auth_idp_passkey_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "keyId" bytea NOT NULL,
    "keyIdBase64" text NOT NULL,
    "clientDataJSON" bytea NOT NULL,
    "attestationObject" bytea NOT NULL,
    "originalChallenge" bytea NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_idp_passkey_account_key_id_base64" ON "serverpod_auth_idp_passkey_account" USING btree ("keyIdBase64");

--
-- Class PasskeyChallenge as table serverpod_auth_idp_passkey_challenge
--
CREATE TABLE "serverpod_auth_idp_passkey_challenge" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "createdAt" timestamp without time zone NOT NULL,
    "challenge" bytea NOT NULL
);

--
-- Class RateLimitedRequestAttempt as table serverpod_auth_idp_rate_limited_request_attempt
--
CREATE TABLE "serverpod_auth_idp_rate_limited_request_attempt" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "domain" text NOT NULL,
    "source" text NOT NULL,
    "key" text NOT NULL,
    "ipAddress" text,
    "attemptedAt" timestamp without time zone NOT NULL,
    "extraData" json
);

-- Indexes
CREATE INDEX "serverpod_auth_idp_rate_limited_request_attempt_composite" ON "serverpod_auth_idp_rate_limited_request_attempt" USING btree ("domain", "source", "key", "attemptedAt");

--
-- Class SecretChallenge as table serverpod_auth_idp_secret_challenge
--
CREATE TABLE "serverpod_auth_idp_secret_challenge" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "challengeCodeHash" text NOT NULL
);

--
-- Class RefreshToken as table serverpod_auth_core_jwt_refresh_token
--
CREATE TABLE "serverpod_auth_core_jwt_refresh_token" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "scopeNames" json NOT NULL,
    "extraClaims" text,
    "method" text NOT NULL,
    "fixedSecret" bytea NOT NULL,
    "rotatingSecretHash" text NOT NULL,
    "lastUpdatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "serverpod_auth_core_jwt_refresh_token_last_updated_at" ON "serverpod_auth_core_jwt_refresh_token" USING btree ("lastUpdatedAt");

--
-- Class UserProfile as table serverpod_auth_core_profile
--
CREATE TABLE "serverpod_auth_core_profile" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "userName" text,
    "fullName" text,
    "email" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "imageId" uuid
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_profile_user_profile_email_auth_user_id" ON "serverpod_auth_core_profile" USING btree ("authUserId");

--
-- Class UserProfileImage as table serverpod_auth_core_profile_image
--
CREATE TABLE "serverpod_auth_core_profile_image" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "userProfileId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "storageId" text NOT NULL,
    "path" text NOT NULL,
    "url" text NOT NULL
);

--
-- Class ServerSideSession as table serverpod_auth_core_session
--
CREATE TABLE "serverpod_auth_core_session" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "scopeNames" json NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "lastUsedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expiresAt" timestamp without time zone,
    "expireAfterUnusedFor" bigint,
    "sessionKeyHash" bytea NOT NULL,
    "sessionKeySalt" bytea NOT NULL,
    "method" text NOT NULL
);

--
-- Class AuthUser as table serverpod_auth_core_user
--
CREATE TABLE "serverpod_auth_core_user" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "createdAt" timestamp without time zone NOT NULL,
    "scopeNames" json NOT NULL,
    "blocked" boolean NOT NULL
);

--
-- Foreign relations for "poodle_account_access" table
--
ALTER TABLE ONLY "poodle_account_access"
    ADD CONSTRAINT "poodle_account_access_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "poodle_account_invitation" table
--
ALTER TABLE ONLY "poodle_account_invitation"
    ADD CONSTRAINT "poodle_account_invitation_fk_0"
    FOREIGN KEY("issuerId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "poodle_account_invitation"
    ADD CONSTRAINT "poodle_account_invitation_fk_1"
    FOREIGN KEY("acceptedById")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;

--
-- Foreign relations for "poodle_course_activity" table
--
ALTER TABLE ONLY "poodle_course_activity"
    ADD CONSTRAINT "poodle_course_activity_fk_0"
    FOREIGN KEY("sectionId")
    REFERENCES "poodle_course_section"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "poodle_course_membership" table
--
ALTER TABLE ONLY "poodle_course_membership"
    ADD CONSTRAINT "poodle_course_membership_fk_0"
    FOREIGN KEY("courseId")
    REFERENCES "poodle_course"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "poodle_course_membership"
    ADD CONSTRAINT "poodle_course_membership_fk_1"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "poodle_course_section" table
--
ALTER TABLE ONLY "poodle_course_section"
    ADD CONSTRAINT "poodle_course_section_fk_0"
    FOREIGN KEY("courseId")
    REFERENCES "poodle_course"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_future_call_claim" table
--
ALTER TABLE ONLY "serverpod_future_call_claim"
    ADD CONSTRAINT "serverpod_future_call_claim_fk_0"
    FOREIGN KEY("futureCallId")
    REFERENCES "serverpod_future_call"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_log" table
--
ALTER TABLE ONLY "serverpod_log"
    ADD CONSTRAINT "serverpod_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_message_log" table
--
ALTER TABLE ONLY "serverpod_message_log"
    ADD CONSTRAINT "serverpod_message_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_query_log" table
--
ALTER TABLE ONLY "serverpod_query_log"
    ADD CONSTRAINT "serverpod_query_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_anonymous_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_anonymous_account"
    ADD CONSTRAINT "serverpod_auth_idp_anonymous_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_apple_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_apple_account"
    ADD CONSTRAINT "serverpod_auth_idp_apple_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_email_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_email_account"
    ADD CONSTRAINT "serverpod_auth_idp_email_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_email_account_password_reset_request" table
--
ALTER TABLE ONLY "serverpod_auth_idp_email_account_password_reset_request"
    ADD CONSTRAINT "serverpod_auth_idp_email_account_password_reset_request_fk_0"
    FOREIGN KEY("emailAccountId")
    REFERENCES "serverpod_auth_idp_email_account"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "serverpod_auth_idp_email_account_password_reset_request"
    ADD CONSTRAINT "serverpod_auth_idp_email_account_password_reset_request_fk_1"
    FOREIGN KEY("challengeId")
    REFERENCES "serverpod_auth_idp_secret_challenge"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "serverpod_auth_idp_email_account_password_reset_request"
    ADD CONSTRAINT "serverpod_auth_idp_email_account_password_reset_request_fk_2"
    FOREIGN KEY("setPasswordChallengeId")
    REFERENCES "serverpod_auth_idp_secret_challenge"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_email_account_request" table
--
ALTER TABLE ONLY "serverpod_auth_idp_email_account_request"
    ADD CONSTRAINT "serverpod_auth_idp_email_account_request_fk_0"
    FOREIGN KEY("challengeId")
    REFERENCES "serverpod_auth_idp_secret_challenge"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "serverpod_auth_idp_email_account_request"
    ADD CONSTRAINT "serverpod_auth_idp_email_account_request_fk_1"
    FOREIGN KEY("createAccountChallengeId")
    REFERENCES "serverpod_auth_idp_secret_challenge"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_facebook_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_facebook_account"
    ADD CONSTRAINT "serverpod_auth_idp_facebook_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_firebase_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_firebase_account"
    ADD CONSTRAINT "serverpod_auth_idp_firebase_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_github_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_github_account"
    ADD CONSTRAINT "serverpod_auth_idp_github_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_google_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_google_account"
    ADD CONSTRAINT "serverpod_auth_idp_google_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_microsoft_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_microsoft_account"
    ADD CONSTRAINT "serverpod_auth_idp_microsoft_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_passkey_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_passkey_account"
    ADD CONSTRAINT "serverpod_auth_idp_passkey_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_core_jwt_refresh_token" table
--
ALTER TABLE ONLY "serverpod_auth_core_jwt_refresh_token"
    ADD CONSTRAINT "serverpod_auth_core_jwt_refresh_token_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_core_profile" table
--
ALTER TABLE ONLY "serverpod_auth_core_profile"
    ADD CONSTRAINT "serverpod_auth_core_profile_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "serverpod_auth_core_profile"
    ADD CONSTRAINT "serverpod_auth_core_profile_fk_1"
    FOREIGN KEY("imageId")
    REFERENCES "serverpod_auth_core_profile_image"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    DEFERRABLE INITIALLY DEFERRED;

--
-- Foreign relations for "serverpod_auth_core_profile_image" table
--
ALTER TABLE ONLY "serverpod_auth_core_profile_image"
    ADD CONSTRAINT "serverpod_auth_core_profile_image_fk_0"
    FOREIGN KEY("userProfileId")
    REFERENCES "serverpod_auth_core_profile"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_core_session" table
--
ALTER TABLE ONLY "serverpod_auth_core_session"
    ADD CONSTRAINT "serverpod_auth_core_session_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR poodle
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('poodle', '20261104225418453-notifications', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261104225418453-notifications', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260924105404509', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105404509', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260924105232991', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105232991', "timestamp" = now();


COMMIT;
