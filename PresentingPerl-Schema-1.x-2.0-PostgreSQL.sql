-- Convert schema './PresentingPerl-Schema-1.x-PostgreSQL.sql' to './PresentingPerl-Schema-2.0-PostgreSQL.sql':;

BEGIN;

ALTER TABLE videos ADD COLUMN external_embed_link text DEFAULT '';


COMMIT;


