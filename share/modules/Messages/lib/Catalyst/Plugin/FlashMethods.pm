package Catalyst::Plugin::FlashMethods;
# From http://modernperlbooks.com/mt/2011/06/making-catalyst-session-flash-methody.html
# ABSTRACT: role to add flash-manipulation methods to Catalyst app

use Moose;

extends 'Catalyst::Plugin::Session';
with 'Catalyst::Plugin::Role::FlashMethods'
    => { flash_elements => [qw( message error )] };

1;
