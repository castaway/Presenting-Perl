package PresentingPerl::Web::View::Zoom::Admin;
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

sub root {
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
       
        } ($stash->{buckets}->all) ];

      $zoom = $zoom->select('#bucket-list')
        ->repeat_content($buckets)
        ->select('.error-text')->replace_content($error);

    $self->wrap($zoom, $stash);
  

}

1;
