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
                   { href => '/admin/plugin',
                     label => 'Plugins'
                   },
                   { href => '/admin/template',
                     label => 'Templates'
                   },
                   { href => '/admin/block',
                     label => 'Blocks'
                   },
                   { href => '/admin/menu',
                     label => 'Menus'
                   },
                   { href => '/admin/link',
                     label => 'Links'
                   },
                   { href => '/admin/system/info',
                     label => 'System/Infos'
                   },
                   { href => '/admin/system/modules',
                     label => 'System/Modules'
                   },
                  ];

  $self->stash('pagelinks', $pagelinks);
}

1;
