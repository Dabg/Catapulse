use strict;
use warnings;
use DBIx::Class::Migration::RunScript;
use DBIx::Class::Migration::RunScript::Trait::AuthenPassphrase;
use Authen::Passphrase::BlowfishCrypt;

my $default_user = $ENV{USER} || 'admin';

migrate {
  my $self = shift;

  my $schema = $self->schema;

  #-------------------------------------#
  #           Users
  #-------------------------------------#
  my @users = $schema->resultset('User')->search->all;


  foreach my $u ( @users) {
    my $pass = Authen::Passphrase::BlowfishCrypt->new(
                                                      cost => 14,
                                                      salt_random => 1,
                                                      passphrase => $u->password,
                                                     )->as_crypt;
    $u->update({
                password => $pass,
               });
  }
};
