package Catapulse::Web::Block::Sidebar;

use Moose;
use namespace::autoclean;

BEGIN {extends 'Catapulse::Web::Block::Base';}

sub process {
  my $self = shift;

  my $pagelinks = [
                   { href => '/admin/user',
                     label => 'Users'
                   },
                   { href => '/admin/role',
                     label => 'Roles'
                   },
                   { href => '/page',
                     label => 'Pages'
                   },
                   { href => '/admin/template',
                     label => 'Templates'
                   },
                   { href => '/admin/block',
                     label => 'Blocks'
                   },
                   { href => '/debug/config',
                     label => 'Debug/config'
                   },
                  ];

  $self->stash('pagelinks', $pagelinks);
}

1;
