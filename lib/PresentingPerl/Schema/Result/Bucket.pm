use utf8;
package PresentingPerl::Schema::Result::Bucket;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

PresentingPerl::Schema::Result::Bucket

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

=head1 TABLE: C<buckets>

=cut

__PACKAGE__->table("buckets");

=head1 ACCESSORS

=head2 slug

  data_type: 'text'
  is_nullable: 0

=head2 name

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "slug",
  { data_type => "text", is_nullable => 0 },
  "name",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</slug>

=back

=cut

__PACKAGE__->set_primary_key("slug");

=head1 RELATIONS

=head2 announcements

Type: has_many

Related object: L<PresentingPerl::Schema::Result::Announcement>

=cut

__PACKAGE__->has_many(
  "announcements",
  "PresentingPerl::Schema::Result::Announcement",
  { "foreign.bucket_slug" => "self.slug" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 videos

Type: has_many

Related object: L<PresentingPerl::Schema::Result::Video>

=cut

__PACKAGE__->has_many(
  "videos",
  "PresentingPerl::Schema::Result::Video",
  { "foreign.bucket_slug" => "self.slug" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2011-12-03 12:17:58
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:wBNqjqvZqIksnTrjVNsO/w

sub video_count {
    my ($self) = @_;
    return $self->videos->count;
}

# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
