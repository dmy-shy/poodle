BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "poodle_account_invitation" DROP CONSTRAINT IF EXISTS "poodle_account_invitation_fk_0";
ALTER TABLE "poodle_account_invitation" DROP CONSTRAINT IF EXISTS "poodle_account_invitation_fk_1";
ALTER TABLE "poodle_account_invitation" ADD COLUMN "universityId" uuid;
ALTER TABLE "poodle_account_invitation" ADD COLUMN "courseId" uuid;
ALTER TABLE "poodle_account_invitation" ALTER COLUMN "issuerId" DROP NOT NULL;
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "poodle_account_invitation"
    ADD CONSTRAINT "poodle_account_invitation_fk_2"
    FOREIGN KEY("issuerId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "poodle_account_invitation"
    ADD CONSTRAINT "poodle_account_invitation_fk_3"
    FOREIGN KEY("acceptedById")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "poodle_account_invitation"
    ADD CONSTRAINT "poodle_account_invitation_fk_0"
    FOREIGN KEY("universityId")
    REFERENCES "poodle_university"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "poodle_account_invitation"
    ADD CONSTRAINT "poodle_account_invitation_fk_1"
    FOREIGN KEY("courseId")
    REFERENCES "poodle_course"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;

--
-- MIGRATION VERSION FOR poodle
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('poodle', '20261113001221234-university-invitations', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261113001221234-university-invitations', "timestamp" = now();

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
