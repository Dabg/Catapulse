use utf8;
package Catapulse::Schema::Result::User;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Catapulse::Schema::Result::User

=cut

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends qw /DBIx::Class::Core Catalyst::Authentication::User /;

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

=head1 TABLE: C<users>

=cut

__PACKAGE__->table("users");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 username

  data_type: 'varchar'
  is_nullable: 0
  size: 40

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 40

=head2 password

  data_type: 'char'
  is_nullable: 0
  size: 40

=head2 email

  data_type: 'varchar'
  is_nullable: 0
  size: 100

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
  "username",
  { data_type => "varchar", is_nullable => 0, size => 40 },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 40 },
  "website",
  { data_type => "varchar", is_nullable => 1, size => 100 },
  "password",
  { data_type => "char", is_nullable => 0, size => 40 },
  "email",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "tzone",
  { data_type => "varchar", is_nullable => 1, size => 100 },
  "created",
  { data_type => "timestamp", is_nullable => 1 },
  "active",
  { data_type => "tinyint", default_value => 0, is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<username_unique>

=over 4

=item * L</username>

=back

=cut

__PACKAGE__->add_unique_constraint("username_unique", ["username"]);

=head1 RELATIONS

=head2 user_roles

Type: has_many

Related object: L<Catapulse::Schema::Result::UserRole>

=cut

__PACKAGE__->has_many(
  "user_roles",
  "Catapulse::Schema::Result::UserRole",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

__PACKAGE__->has_many(
  "user_roles_test",
  "Catapulse::Schema::Result::UserRole",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 roles

Type: many_to_many

Composing rels: L</user_roles> -> role

=cut

__PACKAGE__->many_to_many("roles", "user_roles", "role");


# Created by DBIx::Class::Schema::Loader v0.07017 @ 2012-03-04 11:52:28
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:rqMnaqBaunyFZFAs/D29pg

__PACKAGE__->add_columns(
        "password", {
                     encode_column       => 1,
                     encode_class        => 'Crypt::Eksblowfish::Bcrypt',
                     encode_args         => { salt_random => 1, cost => 14 },
                     encode_check_method => 'check_password',
                     # For some reason deploy() wasn't picking up the type or size
                     # so we set it here again.
                     data_type => 'VARCHAR',
                     size => 100,
                    },
        "created",
                   {
                    data_type     => "timestamp",
                    is_nullable   => 0,
                    inflate_datetime => 'epoch',
                    set_on_create    => 1,
                   },
);


__PACKAGE__->has_many(map_user_roles => 'Catapulse::Schema::Result::UserRole', 'user_id',
                      { cascade_copy => 0, cascade_delete => 0 });

__PACKAGE__->many_to_many(user_roles => 'map_user_roles', 'role',
			  { where => { 'active' => 1 } });


sub activate   { $_[0]->active(1); $_[0]->update(); };
sub deactivate { $_[0]->active(0); $_[0]->update(); };

__PACKAGE__->meta->make_immutable;

1;
