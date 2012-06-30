use strict;
use warnings;
use Test::More;


use Catalyst::Test 'PresentingPerl::Web';
use PresentingPerl::Web::Controller::Archive;

ok( request('/archive')->is_success, 'Request should succeed' );
done_testing();
