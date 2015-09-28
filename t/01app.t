#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

use Catalyst::Test 'Catapulse::Web';

ok( request('/')->is_success, 'Request / should succeed' );
ok( request('/login')->is_success, 'Request /login should succeed' );

done_testing();
