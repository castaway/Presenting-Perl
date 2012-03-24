-- Convert schema './PresentingPerl-Schema-1.x-MySQL.sql' to 'PresentingPerl::Schema v2.0':;

BEGIN;

ALTER TABLE videos ADD COLUMN external_embed_link text DEFAULT '';


COMMIT;


