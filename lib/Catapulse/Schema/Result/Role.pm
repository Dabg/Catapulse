use utf8;
package Catapulse::Schema::Result::Role;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Catapulse::Schema::Result::Role

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=item * L<DBIx::Class::DateTime::Epoch>

=item * L<DBIx::Class::TimeStamp>

=item * L<DBIx::Class::EncodedColumn>

=back

=cut

__PACKAGE__->load_components(
  "InflateColumn::DateTime",
  "DateTime::Epoch",
  "TimeStamp",
  "EncodedColumn",
);

=head1 TABLE: C<roles>

=cut

__PACKAGE__->table("roles");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 active

  data_type: 'tinyint'
  default_value: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 100 },
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

__PACKAGE__->add_unique_constraint("name_unique", ["name"]);

=head1 RELATIONS

=head2 role_roles_inherits_from

Type: has_many

Related object: L<Catapulse::Schema::Result::RoleRole>

=cut

__PACKAGE__->has_many(
  "role_roles_inherits_from",
  "Catapulse::Schema::Result::RoleRole",
  { "foreign.inherits_from_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 role_roles_roles

Type: has_many

Related object: L<Catapulse::Schema::Result::RoleRole>

=cut

__PACKAGE__->has_many(
  "role_roles_roles",
  "Catapulse::Schema::Result::RoleRole",
  { "foreign.role_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 user_roles

Type: has_many

Related object: L<Catapulse::Schema::Result::UserRole>

=cut

__PACKAGE__->has_many(
  "user_roles",
  "Catapulse::Schema::Result::UserRole",
  { "foreign.role_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 inherits_from

Type: many_to_many

Composing rels: L</role_roles_roles> -> inherit_from

=cut

__PACKAGE__->many_to_many("inherits_from", "role_roles_roles", "inherit_from");

=head2 roles

Type: many_to_many

Composing rels: L</role_roles_inherits_from> -> role

=cut

__PACKAGE__->many_to_many("roles", "role_roles_inherits_from", "role");

=head2 users

Type: many_to_many

Composing rels: L</user_roles> -> user

=cut

__PACKAGE__->many_to_many("users", "user_roles", "user");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-10-19 18:59:01
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:7w3Mto1RDkMG3VXaaYrtwA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
