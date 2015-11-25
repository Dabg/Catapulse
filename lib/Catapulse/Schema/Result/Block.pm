use utf8;
package Catapulse::Schema::Result::Block;

=head1 NAME

Catapulse::Schema::Result::Block

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

__PACKAGE__->load_components( "Tree::AdjacencyList::Ordered" );

=head1 TABLE: C<blocks>

=cut

__PACKAGE__->table("blocks");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 type

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 parent_id

  data_type: 'int'
  default_value: 0
  is_nullable: 0

=head2 position

  data_type: 'int'
  is_nullable: 0

=head2 active

  data_type: 'tinyint'
  default_value: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 32 },
  "file",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "parent_id",
  { data_type => "int", default_value => 0, is_nullable => 0 },
  "position",
  { data_type => "int", is_nullable => 1 },
  "active",
  { data_type => "tinyint", default_value => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<name_unique>

=over 4

=item * L</name>

=back

=cut

__PACKAGE__->add_unique_constraint("blockname_unique", ["name"]);

=head2 block_templates

Type: has_many

Related object: L<Catapulse::Schema::Result::TemplateBlock>

=cut

__PACKAGE__->has_many(
  "block_templates",
  "Catapulse::Schema::Result::TemplateBlock",
  { "foreign.block_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


=head2 templates

Type: many_to_many

Composing rels: L</block_templates> -> template

=cut

__PACKAGE__->many_to_many("templates", "block_templates", "template");


=head2 activate

active Block

=cut
sub activate   { $_[0]->active(1); $_[0]->update(); };

=head2 desactivate

desactive Block

=cut
sub deactivate { $_[0]->active(0); $_[0]->update(); };

__PACKAGE__->meta->make_immutable;

1;
