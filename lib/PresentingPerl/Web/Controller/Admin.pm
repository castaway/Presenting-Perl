package PresentingPerl::Web::Controller::Admin;

use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller::ActionRole' }

sub root :Path :Args(0) : Local Does('NeedsLogin') {
    my ($self, $c) = @_;

    unless($c->user->get_object->has_role('admin')) {
        $c->redirect('/login');
    }

    my $buckets = $c->model('DB::Bucket');

    $c->stash->{current_view} = 'Zoom';
    $c->stash->{buckets} = $buckets;
}

__PACKAGE__->meta->make_immutable;

1;
