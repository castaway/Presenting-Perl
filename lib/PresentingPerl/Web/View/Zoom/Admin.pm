package PresentingPerl::Web::View::Zoom::Admin;
use Moose;

use Data::Dumper;
use HTML::Zoom::FilterBuilder::Template;

sub wrap {
  my ($self, $zoom, $stash) = @_;

  my @body;
  
  $zoom->select('#main-content')->collect_content({into => \@body})->run;

  print STDERR Dumper(\@body);

  my $layout_zoom = HTML::Zoom->from_file($stash->{wrapper_template});
  # This does *not* modify $layout_zoom, but rather returns the modified version!
  return $layout_zoom->select('#main-content')->replace_content(\@body);
}

sub all_buckets {
    my ($self, $stash) = @_;

    my $error = $stash->{error} || '';
    my $zoom = $_;
    my $buckets = [ map {
        my $obj = $_;
        sub {
            $_->select('.bucket-slug')->replace_content($obj->slug)
                ->select('.bucket-name')->replace_content($obj->name)
                ->select('.edit-link')->set_attribute(
                'href' => $obj->slug.'/'
                )
                ->select('.delete-link')->set_attribute(
                'href' => $obj->slug.'/delete/'
                )
        }
       
        } ($stash->{buckets_rs}->all) ];

      $zoom = $zoom->select('#bucket-list')
        ->repeat_content($buckets)
        ->select('.error-text')->replace_content($error);

    $self->wrap($zoom, $stash);
  
}

sub edit_bucket {
    my ($self, $stash) = @_;

    my $error = $stash->{error} || '';
    my $zoom = $_;
    my $bucket = $stash->{bucket};

    my $videos = [ map {
        my $obj = $_;
          sub {
            $_->select('.video-name')->replace_content($obj->name)
              ->select('.video-author')->replace_content($obj->author)
              ->select('.video-link')->set_attribute(
                  href => $obj->slug.'/'
                )
          }
        } ($stash->{videos_rs}->all) ];

    $zoom = $zoom->select('#video-list')
        ->repeat_content($videos)
        ->select('.bucket-name')->replace_content($bucket->name)
        ->select('.error-text')->replace_content($error);

    $self->wrap($zoom, $stash);

}

sub edit_video {
    my ($self, $stash) = @_;

    my $error = $stash->{error} || '';
    my $zoom = $_;
    my $video = $stash->{video};

    $zoom = $zoom->select('.video-name')->replace_content($video->name)
        ->select('[name=title]')->add_to_attribute('value', $video->name)
        ->select('[name=author]')->add_to_attribute('value', $video->author)
        ->select('.error-text')->replace_content($error);

    $self->wrap($zoom, $stash);
}

1;
