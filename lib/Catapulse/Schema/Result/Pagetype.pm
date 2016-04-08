use utf8;
package Catapulse::Schema::Result::Pagetype;

=head1 NAME

Catapulse::Schema::Result::Content

=cut

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
use Carp qw/croak/;
extends 'DBIx::Class::Core';

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 40

=head2 path

  data_type: 'varchar'
  is_nullable: 1
  size: 100

=head2 active

  data_type: 'tinyint'
  default_value: 0
  is_nullable: 0

=cut

__PACKAGE__->load_components( "Core" );
__PACKAGE__->table("pagetype");
__PACKAGE__->add_columns(
    "id",
    { data_type => "INTEGER", is_nullable => 0, size => undef, is_auto_increment => 1 },
    "name",
    { data_type => "VARCHAR", is_nullable => 0, size => 40 },
    "path",
    { data_type => "VARCHAR", is_nullable => 1, size => 100 },
    "active",
    { data_type => "tinyint", default_value => 0, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("id");

=head1 NAME

Catapulse::Schema::Result::Patgetype - store page types

=head1 METHODS

=head1 AUTHOR

Daniel Brosseau <dab@catapulse.org>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
