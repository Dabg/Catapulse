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

=item * L</username>

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


__PACKAGE__->belongs_to(
  "type",
  "Catapulse::Schema::Result::Pagetype",
  { id => "type" },
);

__PACKAGE__->belongs_to(
    "content",
    "Catapulse::Schema::Result::Content",
    { page => "id", version => "version" }
);

# __PACKAGE__->belongs_to(
#     "page_version",
#     "Catapulse::Schema::Result::PageVersion",
#     { page => "id", version => "version" }
# );


=head2 comments

Type: has_many

Related object: L<Catapulse::Schema::Result::Comment>

=cut

__PACKAGE__->has_many(
  "comments",
  "Catapulse::Schema::Result::Comment",
  { "foreign.page_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 obj_operations

Type: has_many

Related object: L<Catapulse::Schema::Result::ObjOperation>

=cut

__PACKAGE__->has_many(
  "obj_operations",
  "Catapulse::Schema::Result::ObjOperation",
  { "foreign.obj_id"     => "self.id"} ,
  {  where => { typeobj_id => 1 }},
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 permissions

Type: has_many

Related object: L<Catapulse::Schema::Result::Permission>

=cut

__PACKAGE__->has_many(
  "permissions",
  "Catapulse::Schema::Result::Permission",
  { "foreign.obj_id"     => "self.id"} ,
  {  where => { typeobj_id => 1 }},
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 ops_to_access

Type: many_to_many

=cut

__PACKAGE__->many_to_many( ops_to_access => 'obj_operations', 'operation',);


=head1 METHODS

=cut

=head2 get_permissions

Returns the permissions for a role and an operation

=cut


sub path {
  my $self = shift;

  my @items;
  my $item = $self;
  while ($item) {
      push(@items, $item->name) if $item;
      $item = $item->parent;
  }
  my $ret =  join '/', reverse @items;
  $ret =~ s|//|/|;
  return $ret;
}

=cut

=head2 get_permissions

Returns the permissions for a role and an operation

=cut


sub get_permissions {
  my ($self, $role, $operation ) = @_;

  my $args = {};
  $args->{role_id} = $role->id if ( $role );
  $args->{operation_id} = $operation->id if ( $operation );
  return $self->permissions->search( $args );
}


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


=head2 update_content <%args>

Create a new content version for this page.

%args is each column of L<Catapulse::Schema::Result::Content>.

=cut

# update_content: this whole method may need work to deal with workflow.
# maybe it can't even be called if the site uses workflow...
# may need fixing for better conflict handling, too. maybe use a transaction?

sub update_content {
    my ( $self, %args ) = @_;

    my $content_version = (
          $self->content
        ? $self->content->max_version()
        : undef
    );
    my %content_data =
      map { $_ => $args{$_} }
      $self->result_source->related_source('content')->columns;
    my $now = DateTime->now;
    @content_data{qw/page version status release_date/} = (
        $self->id, ( $content_version ? $content_version + 1 : 1 ),
        'released', $now,
    );

    my $content =
      $self->result_source->related_source('content')
      ->resultset->find_or_create( \%content_data );

    $self->version($content->version);
    $self->update;
}    # end sub update_content


sub activate   { $_[0]->active(1); $_[0]->update(); };
sub deactivate { $_[0]->active(0); $_[0]->update(); };

__PACKAGE__->meta->make_immutable;

1;
