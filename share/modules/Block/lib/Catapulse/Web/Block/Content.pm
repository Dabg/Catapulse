package Catapulse::Web::Block::Content;

use Moose;
use namespace::autoclean;

BEGIN {extends 'Catapulse::Web::Block::Base';}


sub process{
  my $self = shift;
  my $c    = $self->ctx;

  $c->stash->{content} ||= $c->res->body;
}
1;
