CREATE TABLE announcements (
  id INTEGER NOT NULL PRIMARY KEY,
  made_at DATETIME NOT NULL,
  bucket_slug TEXT REFERENCES buckets(slug)
);
CREATE TABLE buckets (
  slug TEXT NOT NULL PRIMARY KEY,
  name TEXT NOT NULL
);
CREATE TABLE videos (
  slug TEXT NOT NULL,
  bucket_slug TEXT NOT NULL REFERENCES buckets(slug),
  name TEXT NOT NULL,
  author TEXT NOT NULL,
  details TEXT NOT NULL DEFAULT '',
  announcement_id INTEGER NOT NULL,
  PRIMARY KEY (slug, bucket_slug),
  FOREIGN KEY (announcement_id, bucket_slug)
    REFERENCES announcements(id, bucket_slug)
);
