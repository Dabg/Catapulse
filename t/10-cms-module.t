#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

BEGIN{
    $ENV{CATALYST_CONFIG} = 't/conf/cms.yml';
}

use Catalyst::Test 'Catapulse::Web';

ok(my(undef, $c) = ctx_request('/'), 'get catalyst context');

my $module_userrole = $c->mi->get_module('UserRole');

is( -e $c->mi->_persist_file_name($module_userrole), 1, 'persistent file exist');

my $schema = $c->model->schema;

is( $schema->resultset('User')->search, 2, 'install work, there are 2 users');
is( $schema->resultset('Role')->search, 2, '... and 2 roles');

ok($c->mi->uninstall_module($module_userrole), 'UnInstall module UserRole');

is( $schema->resultset('User')->search, 0, 'uninstall work, there is no user');

is( $schema->resultset('Role')->search, 0, '... and no role');

is( ! -e $c->mi->_persist_file_name($module_userrole), 1, 'persistent file is deleted');

done_testing();
