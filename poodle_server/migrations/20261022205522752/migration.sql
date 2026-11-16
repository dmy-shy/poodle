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
CREATE TABLE "poodle_course" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "title" text NOT NULL,
    "category" text,
    "summary" text,
    "teacherName" text,
    "seedOwned" boolean NOT NULL DEFAULT false
);

--
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
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
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "poodle_course_activity"
    ADD CONSTRAINT "poodle_course_activity_fk_0"
    FOREIGN KEY("sectionId")
    REFERENCES "poodle_course_section"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
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
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "poodle_course_section"
    ADD CONSTRAINT "poodle_course_section_fk_0"
    FOREIGN KEY("courseId")
    REFERENCES "poodle_course"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR poodle
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('poodle', '20261022205522752', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261022205522752', "timestamp" = now();

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
