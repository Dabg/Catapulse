#!/usr/bin/perl

# from http://perlmaven.com/profiling-and-speed-improvement

# To use it
# $ perl -Ilib -d:NYTProf script/psgi_profiling.pl
# $ nytprofhtml
# and browse nytprof/index.html

use 5.010;
use strict;
use warnings;

my $url = "http://0:3000";

BEGIN {
    $ENV{HTTP_HOST} = $url;
}

use Plack::Test;
use HTTP::Request::Common qw(GET);
use Path::Tiny qw(path);

my $app  = do 'catapulse_web.psgi';
my $test = Plack::Test->create($app);
my $res  = $test->request( GET $url );

say 'ERROR: code is     ' . $res->code . ' instead of 200'   if $res->code != 200;
#say "content=" . $res->content;
