#!/usr/bin/env perl

use Test::Most;
use Test::DBIx::Class
  -schema_class=>'Catapulse::Schema',
  -fixture_class => '::Population',
  qw(User Role);

plan skip_all => 'not correct schema version'
  if Schema->schema_version != 1;

fixtures_ok ['all_tables'];

is User->count, 5, 'Correct Number of Users';
is Role->first->name, 'admin', 'Role name is admin';

done_testing;
