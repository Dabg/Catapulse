use utf8;
package Catapulse::Schema::Result::TemplateBlock;


=head1 NAME

Catapulse::Schema::Result::TemplateBlock

=cut

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<>

=back

=cut

__PACKAGE__->load_components();

=head1 TABLE: C<template_blocks>

=cut

__PACKAGE__->table("template_blocks");

=head1 ACCESSORS

=head2 template_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 block_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "template_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "block_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</template_id>

=item * L</block_id>

=back

=cut

__PACKAGE__->set_primary_key("template_id", "block_id");

=head1 RELATIONS

=head2 block

Type: belongs_to

Related object: L<Catapulse::Schema::Result::Block>

=cut

__PACKAGE__->belongs_to(
  "block",
  "Catapulse::Schema::Result::Block",
  { id => "block_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 template

Type: belongs_to

Related object: L<Catapulse::Schema::Result::Template>

=cut

__PACKAGE__->belongs_to(
  "template",
  "Catapulse::Schema::Result::Template",
  { id => "template_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


__PACKAGE__->meta->make_immutable;
1;
