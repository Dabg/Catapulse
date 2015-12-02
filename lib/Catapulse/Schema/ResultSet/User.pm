package Catapulse::Schema::ResultSet::User;

use Moose;
use namespace::autoclean;
use MooseX::NonMoose;
extends 'Catapulse::Schema::ResultSet';

=head1 NAME

Catapulse::Schema::ResultSet::User - resultset methods on users

=head1 METHODS

=head2 active

Get actived users

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
