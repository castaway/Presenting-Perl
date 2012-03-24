-- Convert schema './PresentingPerl-Schema-1.x-SQLite.sql' to './PresentingPerl-Schema-2.0-SQLite.sql':;

BEGIN;

ALTER TABLE videos ADD COLUMN external_embed_link text DEFAULT '';


COMMIT;


