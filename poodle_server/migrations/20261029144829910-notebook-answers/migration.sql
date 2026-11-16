BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "poodle_notebook_source_version" ADD COLUMN "embeddingSpace" text NOT NULL DEFAULT 'legacy-unidentified'::text;
--
-- ACTION ALTER TABLE
--
ALTER TABLE "poodle_notebook_turn" ADD COLUMN "citationsJson" text NOT NULL DEFAULT '[]'::text;
ALTER TABLE "poodle_notebook_turn" ADD COLUMN "insufficientEvidence" boolean NOT NULL DEFAULT false;

--
-- MIGRATION VERSION FOR poodle
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('poodle', '20261029144829910-notebook-answers', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261029144829910-notebook-answers', "timestamp" = now();

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
