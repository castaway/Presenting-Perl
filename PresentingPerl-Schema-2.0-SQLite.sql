-- 
-- Created by SQL::Translator::Producer::SQLite
-- Created on Sat Mar 24 17:18:30 2012
-- 

BEGIN TRANSACTION;

--
-- Table: announcements
--
DROP TABLE announcements;

CREATE TABLE announcements (
  id INTEGER PRIMARY KEY NOT NULL,
  made_at datetime NOT NULL,
  bucket_slug text,
  FOREIGN KEY(bucket_slug) REFERENCES buckets(slug)
);

CREATE INDEX announcements_idx_bucket_slug ON announcements (bucket_slug);

--
-- Table: buckets
--
DROP TABLE buckets;

CREATE TABLE buckets (
  slug text NOT NULL,
  name text NOT NULL,
  PRIMARY KEY (slug)
);

--
-- Table: roles
--
DROP TABLE roles;

CREATE TABLE roles (
  id INTEGER PRIMARY KEY NOT NULL,
  role text
);

--
-- Table: user_role
--
DROP TABLE user_role;

CREATE TABLE user_role (
  user_id integer NOT NULL,
  role_id integer NOT NULL,
  PRIMARY KEY (user_id, role_id),
  FOREIGN KEY(role_id) REFERENCES roles(id),
  FOREIGN KEY(user_id) REFERENCES users(id)
);

CREATE INDEX user_role_idx_role_id ON user_role (role_id);

CREATE INDEX user_role_idx_user_id ON user_role (user_id);

--
-- Table: users
--
DROP TABLE users;

CREATE TABLE users (
  id INTEGER PRIMARY KEY NOT NULL,
  username text,
  password varchar(255),
  email_address text,
  first_name text,
  last_name text,
  active integer
);

--
-- Table: videos
--
DROP TABLE videos;

CREATE TABLE videos (
  slug text NOT NULL,
  bucket_slug text NOT NULL,
  name text NOT NULL,
  author text NOT NULL,
  details text NOT NULL DEFAULT '',
  external_embed_link text DEFAULT '',
  announcement_id integer NOT NULL,
  PRIMARY KEY (slug, bucket_slug),
  FOREIGN KEY(announcement_id) REFERENCES announcements(id),
  FOREIGN KEY(bucket_slug) REFERENCES buckets(slug)
);

CREATE INDEX videos_idx_announcement_id_bucket_slug ON videos (announcement_id, bucket_slug);

CREATE INDEX videos_idx_bucket_slug ON videos (bucket_slug);

COMMIT;

