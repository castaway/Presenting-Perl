package PresentingPerl::Web::View::Zoom::Root;
use Moose;

use Data::Dumper;
use HTML::Zoom::FilterBuilder::Template;

sub wrap {
  my ($self, $zoom, $stash) = @_;

  my @body;
  
  $zoom->select('#main-content')->collect_content({into => \@body})->run;
  
  my $layout_zoom = HTML::Zoom->from_file($stash->{wrapper_template});
  # This does *not* modify $layout_zoom, but rather returns the modified version!
  return $layout_zoom->select('#main-content')->replace_content(\@body);
}

sub front_page {
  my ($self, $stash) = @_;
  
  my $zoom = $_;
  
  if (!$ENV{TEST_NO_DB}) {
    my $announcements = $stash->{announcements};
    my $ann_list = [ map { 
      my $obj = $_; 
      sub {
        $_->select('.bucket-name')->replace_content($obj->bucket->name)
          ->select('.made-at')->replace_content($obj->made_at->iso8601())
            ->select('.bucket-link')->set_attribute(
                                                    'href' => $obj->bucket->slug.'/'
                                                   )
              #               ->select('.new-videos')->replace_content($obj->video_count)
              ->select('.total-videos')->replace_content(
                                                         $obj->bucket->video_count
                                                        )
            }
    } $announcements->all ];
    
    $zoom = $zoom->select('#announcement-list')->repeat_content($ann_list);
  }
  
  $self->wrap($zoom, $stash);
}


sub bucket {
    my ($self, $stash) = @_;

    my $bucket = $stash->{bucket};
    my $zoom = $_;
    
    my $videos = [ map {
        my $video = $_;
        sub {
            $_->select('.video-name')->replace_content($video->name)
              ->select('.video-author')->replace_content($video->author)
              ->select('.video-link')->set_attribute(
                  href => $video->slug.'/'
                )
        }
                   } $bucket->videos->all ];


    $zoom = $zoom->select('.bucket-name')->replace_content($bucket->name)
        ->select('#video-list')->repeat_content($videos);

    $self->wrap($zoom, $stash);

}

sub video {
    my ($self, $stash) = @_;

    my $video_url = $stash->{video_file};
    my $video = $stash->{video};

    my $zoom = $_;

    $zoom = $zoom->select('.video-name')->replace_content($video->name)
      ->select('.author-name')->replace_content($video->author)
      ->select('.bucket-link')->set_attribute(
          href => '../'
        )
      ->select('.bucket-name')->replace_content($video->bucket->name)
      ->select('.video-details')->replace_content($video->details)
      ->select('script')->template_text_raw({ video_url => $video_url });

    $self->wrap($zoom, $stash);
  
}

1;
