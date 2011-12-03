package PresentingPerl::Web::Controller::Admin;

use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

sub root :Path :Args(0) {
    my ($self, $c) = @_;

    my $buckets = $c->model('DB::Bucket');

    $c->stash->{current_view} = 'Zoom';
    $c->stash->{buckets} = $buckets;
}

__PACKAGE__->meta->make_immutable;

1;
