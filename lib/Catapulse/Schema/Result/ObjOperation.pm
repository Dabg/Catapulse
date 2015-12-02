package Catapulse::Schema::Result::ObjOperation;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("TimeStamp", "EncodedColumn");

=head1 NAME

Catapulse::Schema::Result::ObjOperation

=cut

__PACKAGE__->table("obj_operation");

=head1 ACCESSORS

=head2 typeobj_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 obj_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 operation_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "typeobj_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "obj_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "operation_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);
#__PACKAGE__->set_primary_key("typeobj_id", "obj_id", "operation_id");
__PACKAGE__->add_unique_constraint("typeobj_obj_op_unique", ["typeobj_id", "obj_id", "operation_id"]);

=head1 RELATIONS

=head2 typeobjs

Type: belongs_to

Related object: L<Catapulse::Schema::Result::Typeobj>

=cut

__PACKAGE__->belongs_to(
  "typeobj",
  "Catapulse::Schema::Result::Typeobj",
  { id => "typeobj_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 operations

Type: belongs_to

Related object: L<Catapulse::Schema::Result::Operations>

=cut

__PACKAGE__->belongs_to(
  "operation",
  "Catapulse::Schema::Result::Operation",
  { id => "operation_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-06-02 18:58:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:kuqGfpPTl5RIJPy/3Yvxkg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
