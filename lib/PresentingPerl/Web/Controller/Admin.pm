package PresentingPerl::Web::Controller::Admin;

use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

## This thing runs on HTML::Zoom, look in View::Zoom::Admin to see how the stash is applied to the templates.
sub begin : Private {
    my ($self, $c) = @_;

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
    my ($self, $c, $bucket) = @_;

    ## Find bucket by slug and add bucket object to stash
}

## View/Edit single bucket/Add video
sub edit_bucket :Chained('bucket') :PathPart('') :Args(0) {
}

## admin/buckets/<slug>/<video-slug>
sub edit_video :Chained('bucket') :PathPart('') :Args(1) {
    my ($self, $c, $video_slug) = @_;
}

__PACKAGE__->meta->make_immutable;

1;
