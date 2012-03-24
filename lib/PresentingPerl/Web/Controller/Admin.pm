package PresentingPerl::Web::Controller::Admin;

use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller::ActionRole' }

## This thing runs on HTML::Zoom, look in View::Zoom::Admin to see how the stash is applied to the templates.
sub begin : Private {
    my ($self, $c) = @_;

    unless($c->user_exists && $c->user->get_object->has_role('admin')) {
        return $c->res->redirect($c->uri_for('/login'));
    }

    $c->stash->{current_view} = 'Zoom';
}

## Admin starts here, we fetch the buckets
sub base :Chained('/') :PathPart('admin') :CaptureArgs(0) {
    my ($self, $c) = @_;

    $c->stash({ buckets_rs => $c->model('DB::Bucket') });
}

## Main admin page, links to edit users, buckets etc etc.
sub admin :Chained('base') :PathPart('') :Args(0) {
    my ($self, $c) = @_;
}

sub buckets :Chained('base') :PathPart('buckets') :CaptureArgs(0) {
}

## View all/Create new bucket
sub all_buckets :Chained('buckets') :PathPart('') :Args(0) {
    my ($self, $c) = @_;

    if($c->req->param) {
        my ($slug, $name) = ($c->req->param('new_slug'),
                             $c->req->param('new_name') );
        $c->stash($c->req->params);

        if(!$name || !$slug) {
            $c->stash('error', 'Please fill in both a name and a slug for the new bucket');
            return;
        }

        my $exists = $c->stash->{buckets_rs}->find({ slug => $slug });
        if($exists) {
            $c->stash('error', "The bucket $slug already exists, edit below or choose a new slug");
            return;            
        }

        $c->stash->{buckets_rs}->create({
            slug => $slug,
            name => $name,
                                        });
    }
}

## admin/buckets/<slug>
sub bucket :Chained('buckets') :PathPart('') :CaptureArgs(1) {
    my ($self, $c, $bucket_slug) = @_;

    ## Find bucket by slug and add bucket object to stash
    my $bucket = $c->stash->{buckets_rs}->find({ slug => $bucket_slug });
    if(!$bucket) {
        $c->stash('error', "Bucket $bucket_slug doesn't exist!");
        $c->go($self->action_for('all_buckets'));
    }

    $c->stash('bucket' => $bucket);
}

## View/Edit single bucket/Add video
sub edit_bucket :Chained('bucket') :PathPart('') :Args(0) {
    my ($self, $c) = @_;

    $c->stash->{videos_rs} = $c->stash->{bucket}->videos_rs;

    if($c->req->param) {
        my $name = $c->req->param('new_name');
        my $title = $c->req->param('title');
        my $author = $c->req->param('author');
        $c->stash($c->req->params);

        if(!$name && !$title && !$author) {
            $c->stash('error', 'Please fill in the bucket name or the add video form');
            return;
        }

        if($c->req->param('name')) {
            $c->stash->{bucket}->update({ name => $name });
        } else {

            ## This will currently fail as we have no announcement id!
            (my $slug = lc $name) =~ s/ /-/g;
            $c->stash->{videos_rs}->create({
                author => $author,
                name => $title,
                slug => $slug,
                                           });
        }
    }

}

## admin/buckets/<slug>/<video-slug>
sub edit_video :Chained('bucket') :PathPart('') :Args(1) {
    my ($self, $c, $video_slug) = @_;

    my $video = $c->stash->{bucket}->videos_rs->find({ slug => $video_slug });
    if(!$video) {
        $c->stash('error', "Video $video_slug doesn't exist!");
        $c->go($self->action_for('bucket'), $c->stash->{bucket}->slug);
    }

    if($c->req->param) {
        my ($title, $author) = ($c->req->param('title'),
                             $c->req->param('author') );
        $c->stash($c->req->params);

        if(!$title || !$author) {
            $c->stash('error', 'Please fill in both an author and a title for the video');
            return;
        }

        $c->stash->{video}->update({
            name => $title,
            author => $author,
                                   });
    }

    $c->stash('video' => $video);
    
}

__PACKAGE__->meta->make_immutable;

1;
