package PresentingPerl::Web::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }
use List::Util qw(first);
use URI::Escape;


#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config(namespace => '');

=head1 NAME

PresentingPerl::Web::Controller::Root - Root Controller for PresentingPerl::Web

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 auto

This gets run for everything.

=cut

sub auto :Private {
  my ($self, $c) = @_;

  $c->stash->{wrapper_template} = $c->path_to('root/pp-templates/html/layout.html');

#  my $base_uri = $c->req->base;
#  $base_uri =~ s/\.index.psgi//;
#  $c->req->base($base_uri);
}

=head2 front_page

The root page (/)

=cut

sub front_page :Path :Args(0) {
    my ($self, $c) = @_;

    $c->stash->{current_view} = 'Zoom';
    $c->stash->{announcements} = $c->model("DB::Announcement")->top_n(5);
}

sub bucket :Path :Args(1) {
    my ($self, $c, $bucket) = @_;

    my $bucketrow = $c->model('DB::Bucket')->find({ slug => $bucket });

    return $c->forward('default') if(!$bucketrow);

    $c->stash->{current_view} = 'Zoom';
    $c->stash->{bucket} = $bucketrow;
}

sub video :Path :Args(2) {
    my ($self, $c, $bucket, $video) = @_;

    my $videorow = $c->model('DB::Video')->find({ slug => $video });
    if(!$videorow) {
        $c->debug("Can't find a videorow for $video");
        return $c->forward('default');
    }
    my $video_file = first { 
      -e join('/', $c->path_to('root/static'), $_)
    } map {
        join('/', 'videos', $videorow->bucket->slug, $videorow->slug, uri_escape($videorow->file_name).".$_")
    } @{ $c->config->{SupportedFormats} };

    $c->log->debug("File: $video_file, row: $videorow");
    return $c->forward('default') if(!$videorow || (!$video_file && !$videorow->external_embed_link));

    if($video_file) {
        my $base_uri = $c->req->base->as_string;
        $base_uri =~ s{index.psgi/}{};
#        $video_file = uri_escape($video_file);
        $c->log->debug("Setting video url using: $base_uri\n");
        $video_file = $base_uri . 'static/' . $video_file;
#        $video_file = $c->req->base . 'static/' . $video_file;
#        $video_file = $c->uri_for('/static/' . $video_file);
    }
 
    $c->stash->{current_view} = 'Zoom';
    $c->stash->{video} = $videorow;
    if($videorow->external_embed_link) {
	$c->log->debug("Got a youtube video");
	$c->stash->{video_file} = $videorow->external_embed_link;
	$c->stash->{video_type} = 'youtube';
    } else {
	$c->stash->{video_type} = 'local';
	$c->stash->{video_file} = $video_file;
    }

}

# sub index :Path :Args(0) {
#     my ( $self, $c ) = @_;

#     # Hello World
#     $c->response->body( $c->welcome_message );
# }

=head2 default

Standard 404 error page

=cut

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {}

=head2 denied

Access denied

=cut

sub denied :Private {
    my ($self, $c) = @_;

    $c->res->status('403');
    $c->res->body('Denied!');
}

=head1 AUTHOR

Catalyst developer

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
