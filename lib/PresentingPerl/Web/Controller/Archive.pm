package PresentingPerl::Web::Controller::Archive;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

PresentingPerl::Web::Controller::Archive - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

The archive page (/archive)

=cut

sub index :Path :Args(0) {
    my ($self, $c) = @_;

    $c->stash->{current_view} = 'Zoom';
    $c->stash->{announcements} = $c->model('DB::Announcement')->search(
        {},
        {
            'group_by' => 'bucket_slug',
            'order_by' => { -desc => 'made_at' },
        },
    );
}


=head1 AUTHOR

Robin Smidsrød,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
