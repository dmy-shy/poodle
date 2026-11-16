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
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
--
CREATE TABLE "poodle_notebook_source_version" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "sourceId" uuid NOT NULL,
    "version" bigint NOT NULL,
    "checksum" text NOT NULL,
    "title" text NOT NULL,
    "extractedText" text NOT NULL,
    "status" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "poodle_notebook_version_unique" ON "poodle_notebook_source_version" USING btree ("sourceId", "version");
CREATE INDEX "poodle_notebook_version_checksum" ON "poodle_notebook_source_version" USING btree ("checksum");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "poodle_notebook_turn" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "notebookId" uuid NOT NULL,
    "ownerUserId" uuid NOT NULL,
    "requestKey" text NOT NULL,
    "turnIndex" bigint NOT NULL,
    "role" text NOT NULL,
    "content" text NOT NULL,
    "sourceRevision" bigint NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "poodle_notebook_turn_order" ON "poodle_notebook_turn" USING btree ("notebookId", "turnIndex");
CREATE UNIQUE INDEX "poodle_notebook_turn_request" ON "poodle_notebook_turn" USING btree ("ownerUserId", "requestKey");

--
-- ACTION CREATE TABLE
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
-- MIGRATION VERSION FOR poodle
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('poodle', '20261029130710820-notebook', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261029130710820-notebook', "timestamp" = now();

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
