use utf8;
package Catapulse::Schema::Result::Page;

=head1 NAME

Catapulse::Schema::Result::Page

=cut

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::DateTime::Epoch>

=item * L<DBIx::Class::TimeStamp>

=back

=cut

__PACKAGE__->load_components(qw(
  InflateColumn::DateTime
  DateTime::Epoch
  TimeStamp
  Tree::AdjacencyList
));

=head1 TABLE: C<pages>

=cut

__PACKAGE__->table("pages");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 title

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 name

  data_type: 'varchar'
  is_nullable: 0

=head2 parent_id

  data_type: 'integer'
  is_nullable: 0
  default_value: 0

=head2 type

  data_type: 'integer'
  is_nullable: 0
  size: 255

=head2 created

  data_type: 'timestamp'
  is_nullable: 0

=head2 active

  data_type: 'tinyint'
  default_value: 0
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "title",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "name",
  { data_type => "varchar", is_nullable => 1, size => undef },
  "parent_id",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "type",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0, size => undef },
  "template",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0, size => undef },
  "created",
  {
   data_type     => "timestamp",
   is_nullable   => 0,
   inflate_datetime => 'epoch',
   set_on_create    => 1,
  },
  "active",
  { data_type => "tinyint", default_value => 0, is_nullable => 0 },
  "version",
  { data_type => "INTEGER", is_nullable => 1, size => undef },
  # "content_version",
  # { data_type => "INTEGER", is_nullable => 1, size => undef },
);


=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<name_parent_unique>

=over 4

=item * L</name>

=item * L</parent_id>

=back

=cut

__PACKAGE__->add_unique_constraint("name_parent_unique", ["name", "parent_id"]);

=head1 AdjacencyList

=over 4

=item * L</parent_column>

=back

=cut

__PACKAGE__->parent_column('parent_id');

=head1 RELATIONS


=head2 template


Type: belong_to

Related object: L<Catapulse::Schema::Result::Template>

=cut

__PACKAGE__->belongs_to(
  "template",
  "Catapulse::Schema::Result::Template",
  { id => "template" },
);


=head2 type

Type: belong_to

Related object: L<Catapulse::Schema::Result::PageType>

=cut

__PACKAGE__->belongs_to(
  "type",
  "Catapulse::Schema::Result::Pagetype",
  { id => "type" },
);



=head1 METHODS

=cut


=head2 all_nodes

Returns all parents and itself

=cut


sub all_nodes {
  my $self = shift;

  my $obj = $self;
  my $nodes = [ $self ];
  while ( my $node = $obj->parent) {
    push(@$nodes, $node);
    $obj = $node;
  }
  return reverse @$nodes;
}


=head2 activate

active Page

=cut

sub activate   { $_[0]->active(1); $_[0]->update(); };

=head2 desactivate

desactive Page

=cut

sub deactivate { $_[0]->active(0); $_[0]->update(); };

__PACKAGE__->meta->make_immutable;

1;
