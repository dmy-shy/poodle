BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "poodle_notification" ADD COLUMN "requestId" uuid;

--
-- MIGRATION VERSION FOR poodle
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('poodle', '20261115160335121-university_request_alerts', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261115160335121-university_request_alerts', "timestamp" = now();

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
