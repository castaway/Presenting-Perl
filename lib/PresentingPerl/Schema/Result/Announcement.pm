use utf8;
package PresentingPerl::Schema::Result::Announcement;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

PresentingPerl::Schema::Result::Announcement

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<announcements>

=cut

__PACKAGE__->table("announcements");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 made_at

  data_type: 'datetime'
  is_nullable: 0

=head2 bucket_slug

  data_type: 'text'
  is_foreign_key: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "made_at",
  { data_type => "datetime", is_nullable => 0 },
  "bucket_slug",
  { data_type => "text", is_foreign_key => 1, is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 bucket_slug

Type: belongs_to

Related object: L<PresentingPerl::Schema::Result::Bucket>

=cut

__PACKAGE__->belongs_to(
  "bucket",
  "PresentingPerl::Schema::Result::Bucket",
  { slug => "bucket_slug" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 videos

Type: has_many

Related object: L<PresentingPerl::Schema::Result::Video>

=cut

__PACKAGE__->has_many(
  "videos",
  "PresentingPerl::Schema::Result::Video",
  {
    "foreign.announcement_id" => "self.id",
    "foreign.bucket_slug"     => "self.bucket_slug",
  },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2011-12-03 12:17:58
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:YiCgHA+Rf9Htq8Fm4DMndA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
