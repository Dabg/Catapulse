use utf8;
package Catapulse::Schema::Result::UserRole;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Catapulse::Schema::Result::UserRole

=cut

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

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

=head1 TABLE: C<user_roles>

=cut

__PACKAGE__->table("user_roles");

=head1 ACCESSORS

=head2 user_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 role_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "user_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "role_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</user_id>

=item * L</role_id>

=back

=cut

__PACKAGE__->set_primary_key("user_id", "role_id");

=head1 RELATIONS

=head2 role

Type: belongs_to

Related object: L<Catapulse::Schema::Result::Role>

=cut

__PACKAGE__->belongs_to(
  "role",
  "Catapulse::Schema::Result::Role",
  { id => "role_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 user

Type: belongs_to

Related object: L<Catapulse::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "user",
  "Catapulse::Schema::Result::User",
  { id => "user_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-10-19 18:59:01
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:4rIrJKmZ0P/thENVGfb3xw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
