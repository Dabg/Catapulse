package Catapulse::Web::Controller::Admin;

use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }


=head1 NAME

MyApp::Controller::Admin - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


sub index
:Path :Args(0) {
  my ( $self, $c ) = @_;

}


=head1 AUTHOR

Daniel Brosseau C<dab@catapulse.org>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
