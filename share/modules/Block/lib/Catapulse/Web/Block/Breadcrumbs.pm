package Catapulse::Web::Block::Breadcrumbs;

use Moose;
use namespace::autoclean;
use URI::Escape;

BEGIN {extends 'Catapulse::Web::Block::Base';}

sub process {
  my $self = shift;

  my $paths = [ split m{/}, uri_unescape($self->ctx->req->uri->path) ];
  $self->stash('paths', $paths);
}
1;
