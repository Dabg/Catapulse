package Catapulse::Web::Block::Sidebar;

=head1 NAME

Catapulse::Web::Block::Sidebar

=cut

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

=head1 SEE ALSO

L<Catapulse>

=head1 AUTHOR

Daniel Brosseau, 2016, <dab@catapulse.org>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
