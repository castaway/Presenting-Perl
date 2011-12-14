package PresentingPerl::Web::Controller::Admin::Users;

use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller::ActionRole' }


sub edit :Path :Args(1) : Local Does('NeedsLogin') {
    my ($self, $c, $user_id) = @_;

    unless($c->user->get_object->has_role('admin')) {
        $c->redirect('/login');
    }

    # Stash user details
    $c->stash->{ user } = $c->model( 'DB::User' )->find({
        id => $user_id,
    });

    # Stash the list of roles
    my @roles = $c->model( 'DB::Role' )->search;
    $c->stash->{ roles } = \@roles;
}











sub root :Path :Args(0) : Local Does('NeedsLogin') {
    my ($self, $c) = @_;

    unless($c->user->get_object->has_role('admin')) {
        $c->redirect('/login');
    }

    # Stash the list of users
    my @users = $c->model( 'DB::User' )->search(
        {},
        {
            order_by => 'username',
        },
    );

    $c->stash->{ users } = \@users;
}




__PACKAGE__->meta->make_immutable;

1;
