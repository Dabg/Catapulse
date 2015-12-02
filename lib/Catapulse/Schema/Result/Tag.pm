use utf8;
package Catapulse::Schema::Result::Tag;

=head1 NAME

Catapulse::Schema::Result::Content

=cut

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
use Carp qw/croak/;
extends 'DBIx::Class::Core';

__PACKAGE__->load_components( "Core" );
__PACKAGE__->table("tag");
__PACKAGE__->add_columns(
    "id",
    { data_type => "INTEGER", is_nullable => 0, size => undef, is_auto_increment => 1 },
    "name",
    { data_type => "VARCHAR", is_nullable => 0, size => 100 },
    "active",
    { data_type => "tinyint", default_value => 0, is_nullable => 0 },
);
#   "person",
#   { data_type => "INTEGER", is_nullable => 0, size => undef },
#   "page",
#   { data_type => "INTEGER", is_nullable => 1, size => undef },
#   "photo",
#   { data_type => "INTEGER", is_nullable => 1, size => undef },
__PACKAGE__->set_primary_key("id");
#__PACKAGE__->belongs_to( "person", "Catapulse::Schema::Result::User", { id => "person" } );
#__PACKAGE__->belongs_to( "page",   "Catapulse::Schema::Result::Page",   { id => "page" } );
#__PACKAGE__->belongs_to( "photo",  "Catapulse::Schema::Result::Photo",  { id => "photo" } );

=head2 ops_to_accesss

Type: has_many

Related object: L<Catapulse::Schema::Result::ObjOperation>

=cut

__PACKAGE__->has_many(
  "obj_operations",
  "Catapulse::Schema::Result::ObjOperation",
  { "foreign.obj_id"     => "self.id"} ,
  {  where => { typeobj_id => 2 }},
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 ops_to_access

Type: many_to_many

=cut

__PACKAGE__->many_to_many( ops_to_access => 'obj_operations', 'operation',);

=head1 NAME

Catapulse::Schema::Result::Tag - store page tags

=head1 METHODS

=head2 refcount

Convenience method to return get_column('refcount') if this column
is available.

=cut

sub refcount {
    my $self = shift;
    return $self->get_column('refcount') if $self->has_column_loaded('refcount');
    croak 'Tried to call refcount on resultset without column';
}


=head1 AUTHOR

Marcus Ramberg <mramberg@cpan.org>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
