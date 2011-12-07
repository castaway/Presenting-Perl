package PresentingPerl::Web::Controller::Admin;

use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller::ActionRole' }

sub root :Path :Args(0) {
    my ($self, $c) = @_;

    my $user;

    if($user = $c->user) {
        unless($user->get_object->has_role('admin')) {
            $c->redirect('/login');
        }
    }

    else {
        $c->redirect('/login');

    }

    my $buckets = $c->model('DB::Bucket');

    $c->stash->{current_view} = 'Zoom';
    $c->stash->{buckets} = $buckets;
}

__PACKAGE__->meta->make_immutable;

1;
