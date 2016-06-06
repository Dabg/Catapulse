package Catapulse::Schema::ResultSet::Block;

use Moose;
use namespace::autoclean;
use MooseX::NonMoose;
extends 'Catapulse::Schema::ResultSet';

=head1 NAME

Catapulse::Schema::ResultSet::Block - resultset methods on blocks

=head1 METHODS

=head2 actived

Get actived blocks

=cut

sub actived {
    my ( $self ) = @_;
    return $self->search( { active => 1 } );
}


=head1 AUTHOR

Daniel Brosseau <dab@catapulse.org>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
