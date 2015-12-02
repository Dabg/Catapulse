package Catapulse::Schema::ResultSet;

use Moose;
use namespace::autoclean;
use MooseX::NonMoose;
extends 'DBIx::Class::ResultSet';

=head1 NAME

Catapulse::Schema::ResultSet - common resultset methods

=head1 METHODS

=head2 all_as_array

=cut

sub all_as_array {
  shift->search({},{ result_class =>
                     'DBIx::Class::ResultClass::HashRefInflator' })->all;
}

=head2 all_as_arrayref

=cut

sub all_as_arrayref { [shift->all_as_array] }


=head1 AUTHOR

Daniel Brosseau <dab@catapulse.org>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
