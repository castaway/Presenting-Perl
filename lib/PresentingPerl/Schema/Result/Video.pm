use utf8;
package PresentingPerl::Schema::Result::Video;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

PresentingPerl::Schema::Result::Video

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

=head1 TABLE: C<videos>

=cut

__PACKAGE__->table("videos");

=head1 ACCESSORS

=head2 slug

  data_type: 'text'
  is_nullable: 0

=head2 bucket_slug

  data_type: 'text'
  is_foreign_key: 1
  is_nullable: 0

=head2 name

  data_type: 'text'
  is_nullable: 0

=head2 author

  data_type: 'text'
  is_nullable: 0

=head2 details

  data_type: 'text'
  default_value: (empty string)
  is_nullable: 0

=head2 announcement_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "slug",
  { data_type => "text", is_nullable => 0 },
  "bucket_slug",
  { data_type => "text", is_foreign_key => 1, is_nullable => 0 },
  "name",
  { data_type => "text", is_nullable => 0 },
  "author",
  { data_type => "text", is_nullable => 0 },
  "details",
  { data_type => "text", default_value => "", is_nullable => 0 },
  "announcement_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</slug>

=item * L</bucket_slug>

=back

=cut

__PACKAGE__->set_primary_key("slug", "bucket_slug");

=head1 RELATIONS

=head2 announcement

Type: belongs_to

Related object: L<PresentingPerl::Schema::Result::Announcement>

=cut

__PACKAGE__->belongs_to(
  "announcement",
  "PresentingPerl::Schema::Result::Announcement",
  { bucket_slug => "bucket_slug", id => "announcement_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 bucket_slug

Type: belongs_to

Related object: L<PresentingPerl::Schema::Result::Bucket>

=cut

__PACKAGE__->belongs_to(
  "bucket_slug",
  "PresentingPerl::Schema::Result::Bucket",
  { slug => "bucket_slug" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2011-12-03 12:17:58
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:W4NNNp9swn107y7yM69idw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
