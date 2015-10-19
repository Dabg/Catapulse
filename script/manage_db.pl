#!/usr/bin/env perl

use FindBin;
use lib "$FindBin::Bin/../lib";

use Catapulse::Web;
use DBIx::Class::Migration::Script;

DBIx::Class::Migration::Script
    ->run_with_options(
        schema => Catapulse::Web->model('DBIC')->schema);
