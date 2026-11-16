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
CREATE TABLE "poodle_administrator_request" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "name" text NOT NULL,
    "email" text NOT NULL,
    "university" text NOT NULL,
    "position" text NOT NULL,
    "note" text NOT NULL,
    "locale" text NOT NULL,
    "status" text NOT NULL DEFAULT 'unverified'::text,
    "codeHash" text NOT NULL,
    "attempts" bigint NOT NULL DEFAULT 0,
    "expiresAt" timestamp without time zone NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "verifiedAt" timestamp without time zone,
    "reviewedAt" timestamp without time zone,
    "reviewerId" uuid,
    "reviewNote" text,
    "approvedUniversityId" uuid
);

-- Indexes
CREATE INDEX "poodle_admin_request_email" ON "poodle_administrator_request" USING btree ("email");
CREATE INDEX "poodle_admin_request_status" ON "poodle_administrator_request" USING btree ("status", "createdAt");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "poodle_institution_mail" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "key" text NOT NULL,
    "email" text NOT NULL,
    "subject" text NOT NULL,
    "body" text NOT NULL,
    "attempts" bigint NOT NULL DEFAULT 0,
    "availableAt" timestamp without time zone NOT NULL,
    "deliveredAt" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "poodle_institution_mail_key" ON "poodle_institution_mail" USING btree ("key");
CREATE INDEX "poodle_institution_mail_pending" ON "poodle_institution_mail" USING btree ("deliveredAt", "availableAt");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "poodle_administrator_request"
    ADD CONSTRAINT "poodle_administrator_request_fk_0"
    FOREIGN KEY("reviewerId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "poodle_administrator_request"
    ADD CONSTRAINT "poodle_administrator_request_fk_1"
    FOREIGN KEY("approvedUniversityId")
    REFERENCES "poodle_university"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR poodle
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('poodle', '20261113000904296-administrator-request-review', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261113000904296-administrator-request-review', "timestamp" = now();

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
