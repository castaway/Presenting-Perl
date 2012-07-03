package PresentingPerl::Web::View::Zoom::Archive;
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

sub index {
  my ($self, $stash) = @_;

  my $zoom = $_;

  if (!$ENV{TEST_NO_DB}) {
    my $dt_formatter = sub {
        my ($dt) = @_;
        return '' unless blessed($dt) and $dt->isa('DateTime');
        return $dt->ymd('-');
    };
    my $announcements = $stash->{announcements};
    my $ann_list = [
        map {
            my $obj = $_;
            sub {
                $_->select('.bucket-name')->replace_content( $obj->bucket->name )->select('.made-at')
                    ->replace_content( $dt_formatter->($obj->made_at) )->select('.bucket-link')
                    ->set_attribute( 'href' => '/' . $obj->bucket->slug . '/' )
                    #->select('.new-videos')->replace_content($obj->video_count)
                    ->select('.total-videos')->replace_content( $obj->bucket->video_count );
                }
            } $announcements->all
    ];

    $zoom = $zoom->select('#announcement-list')->repeat_content($ann_list);
  }

  $self->wrap($zoom, $stash);
}

1;
