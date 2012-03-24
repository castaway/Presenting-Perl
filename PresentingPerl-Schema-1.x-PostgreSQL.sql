-- 
-- Created by SQL::Translator::Producer::PostgreSQL
-- Created on Sat Mar 24 11:21:52 2012
-- 
--
-- Table: announcements
--
DROP TABLE "announcements" CASCADE;
CREATE TABLE "announcements" (
  "id" serial NOT NULL,
  "made_at" timestamp NOT NULL,
  "bucket_slug" text,
  PRIMARY KEY ("id")
);
CREATE INDEX "announcements_idx_bucket_slug" on "announcements" ("bucket_slug");

--
-- Table: buckets
--
DROP TABLE "buckets" CASCADE;
CREATE TABLE "buckets" (
  "slug" text NOT NULL,
  "name" text NOT NULL,
  PRIMARY KEY ("slug")
);

--
-- Table: roles
--
DROP TABLE "roles" CASCADE;
CREATE TABLE "roles" (
  "id" serial NOT NULL,
  "role" text,
  PRIMARY KEY ("id")
);

--
-- Table: user_role
--
DROP TABLE "user_role" CASCADE;
CREATE TABLE "user_role" (
  "user_id" integer NOT NULL,
  "role_id" integer NOT NULL,
  PRIMARY KEY ("user_id", "role_id")
);
CREATE INDEX "user_role_idx_role_id" on "user_role" ("role_id");
CREATE INDEX "user_role_idx_user_id" on "user_role" ("user_id");

--
-- Table: users
--
DROP TABLE "users" CASCADE;
CREATE TABLE "users" (
  "id" serial NOT NULL,
  "username" text,
  "password" character varying(255),
  "email_address" text,
  "first_name" text,
  "last_name" text,
  "active" integer,
  PRIMARY KEY ("id")
);

--
-- Table: videos
--
DROP TABLE "videos" CASCADE;
CREATE TABLE "videos" (
  "slug" text NOT NULL,
  "bucket_slug" text NOT NULL,
  "name" text NOT NULL,
  "author" text NOT NULL,
  "details" text DEFAULT '' NOT NULL,
  "announcement_id" integer NOT NULL,
  PRIMARY KEY ("slug", "bucket_slug")
);
CREATE INDEX "videos_idx_announcement_id_bucket_slug" on "videos" ("announcement_id", "bucket_slug");
CREATE INDEX "videos_idx_bucket_slug" on "videos" ("bucket_slug");

--
-- Foreign Key Definitions
--

ALTER TABLE "announcements" ADD FOREIGN KEY ("bucket_slug")
  REFERENCES "buckets" ("slug") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "user_role" ADD FOREIGN KEY ("role_id")
  REFERENCES "roles" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "user_role" ADD FOREIGN KEY ("user_id")
  REFERENCES "users" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "videos" ADD FOREIGN KEY ("announcement_id", "bucket_slug")
  REFERENCES "announcements" ("id", "bucket_slug") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "videos" ADD FOREIGN KEY ("bucket_slug")
  REFERENCES "buckets" ("slug") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;


