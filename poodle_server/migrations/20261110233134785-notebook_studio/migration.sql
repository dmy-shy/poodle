BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "poodle_notebook_artifact" ADD COLUMN "jobId" uuid;
ALTER TABLE "poodle_notebook_artifact" ADD COLUMN "language" text;
ALTER TABLE "poodle_notebook_artifact" ADD COLUMN "sourceSnapshotJson" text;
ALTER TABLE "poodle_notebook_artifact" ADD COLUMN "audioStoragePath" text;
CREATE UNIQUE INDEX "poodle_notebook_artifact_job" ON "poodle_notebook_artifact" USING btree ("jobId");

--
-- MIGRATION VERSION FOR poodle
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('poodle', '20261110233134785-notebook_studio', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261110233134785-notebook_studio', "timestamp" = now();

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
