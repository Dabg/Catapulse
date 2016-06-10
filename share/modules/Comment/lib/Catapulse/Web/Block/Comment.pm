package Catapulse::Web::Block::Comment;

use Moose;
use namespace::autoclean;
use URI::Escape;

BEGIN {extends 'Catapulse::Web::Block::Base';}

sub process {
  my $self = shift;

  my $page = $self->ctx->stash->{page};
  my $comments  = $self->ctx->model('DBIC::Comment')->search(
                                      { page_id => $page->id } );

  $self->ctx->stash('comments', $comments);
}


1;
