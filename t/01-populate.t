#!/usr/bin/env perl

use Test::Most;
use Test::DBIx::Class
  -schema_class=>'Catapulse::Schema',
  -fixture_class => '::Population',
  qw(User Role);

plan skip_all => 'not correct schema version'
  if Schema->schema_version != 1;

fixtures_ok ['all_tables', 'all_tests'];

is User->count, 3, 'Correct Number of Users for tests (without admin and anonymous)';
is Role->first->name, 'user', 'Role name is admin';

done_testing;
