package Catapulse::Web::Block::Content;

=head1 NAME

Catapulse::Web::Block::Content

=cut

use Moose;
use namespace::autoclean;

BEGIN {extends 'Catapulse::Web::Block::Base';}


sub process{
  my $self = shift;
  my $c    = $self->ctx;

  $c->stash->{content} ||= $c->res->body;
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
