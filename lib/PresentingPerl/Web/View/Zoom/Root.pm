package PresentingPerl::Web::View::Zoom::Root;
use Moose;

use Data::Dumper;

sub front_page {
    my ($self, $stash) = @_;

    my $announcements = $stash->{announcements};
    $_->select('#announcement-list')->replace_content("YooHoo!");



#     $_->select('#announcement-list')
#         ->repeat_content(sub {
#             return [ 'foo', 'bar' ];
#             [
#                 map {
#                     my $obj = $_;
#                     sub {
#                         $_->select('.bucket-name')->replace_content($obj->bucket->name)
#                             ->select('.made-at')->replace_content($obj->made_at)
#                             ->select('.bucket-link')->set_attribute(
#                             'href' => $obj->bucket->slug.'/'
#                             )
# #                    ->select('.new-videos')->replace_content($obj->video_count)
# #                    ->select('.total-videos')->replace_content(
# #                    $obj->bucket->video_count
# #                    )
#                     }
#                 } $announcements->all ]
#                          }
#     );
}

1;
