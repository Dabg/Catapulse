package Catapulse::Web::Block::Breadcrumbs;

=head1 NAME

Catapulse::Web::Block::Breadcrumbs

=cut

use Moose;
use namespace::autoclean;
use URI::Escape;

BEGIN {extends 'Catapulse::Web::Block::Base';}

sub process {
  my $self = shift;

  my $paths = [ split m{/}, uri_unescape($self->ctx->req->uri->path) ];
  $self->stash('paths', $paths);
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
