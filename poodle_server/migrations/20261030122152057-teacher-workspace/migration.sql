BEGIN;

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
CREATE TABLE "poodle_teacher_defaults" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "ownerId" uuid NOT NULL,
    "settings" json NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "poodle_teacher_defaults_unique" ON "poodle_teacher_defaults" USING btree ("ownerId");

--
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
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
-- MIGRATION VERSION FOR poodle
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('poodle', '20261030122152057-teacher-workspace', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261030122152057-teacher-workspace', "timestamp" = now();

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
