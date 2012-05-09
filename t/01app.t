#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

use Catalyst::Test 'PresentingPerl::Web';

ok( request('/')->is_success, 'Request should succeed' );

my $not_found_request = request('/this_url_should_not_exist');

ok( !$not_found_request->is_success, 'Request for missing page should not succeed' );
ok( $not_found_request->code == 404, 'Request for missing page should 404' );

done_testing();
