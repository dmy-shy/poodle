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
-- ACTION CREATE TABLE
--
CREATE TABLE "poodle_search_history" (
    "id" bigserial PRIMARY KEY,
    "authUserId" uuid NOT NULL,
    "query" text NOT NULL,
    "normalized" text NOT NULL,
    "lastUsed" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "poodle_search_history_unique" ON "poodle_search_history" USING btree ("authUserId", "normalized");
CREATE INDEX "poodle_search_history_expiry" ON "poodle_search_history" USING btree ("lastUsed");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "poodle_search_index_chunk" (
    "id" bigserial PRIMARY KEY,
    "jobId" bigint NOT NULL,
    "ordinal" bigint NOT NULL,
    "content" text NOT NULL,
    "page" bigint,
    "location" text,
    "embeddingSpace" text NOT NULL,
    "embedding" vector(1536)
);

-- Indexes
CREATE UNIQUE INDEX "poodle_search_chunk_unique" ON "poodle_search_index_chunk" USING btree ("jobId", "ordinal");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "poodle_search_index_job" (
    "id" bigserial PRIMARY KEY,
    "fingerprint" text NOT NULL,
    "targetId" uuid NOT NULL,
    "attempts" bigint NOT NULL DEFAULT 0,
    "state" text NOT NULL DEFAULT 'queued'::text,
    "availableAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "leaseUntil" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "poodle_search_job_unique" ON "poodle_search_index_job" USING btree ("fingerprint");
CREATE INDEX "poodle_search_job_pending" ON "poodle_search_index_job" USING btree ("state", "availableAt");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "poodle_search_history"
    ADD CONSTRAINT "poodle_search_history_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "poodle_search_index_chunk"
    ADD CONSTRAINT "poodle_search_index_chunk_fk_0"
    FOREIGN KEY("jobId")
    REFERENCES "poodle_search_index_job"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR poodle
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('poodle', '20261106003850088-semantic-search', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261106003850088-semantic-search', "timestamp" = now();

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
