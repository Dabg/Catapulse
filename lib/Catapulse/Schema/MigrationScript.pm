package Catapulse::Schema::MigrationScript;

use Moose;
use Catapulse::Web;

extends 'DBIx::Class::Migration::Script';

sub defaults {
  schema => Catapulse::Web->model('DBIC')->schema,
}

__PACKAGE__->meta->make_immutable;
__PACKAGE__->run_if_script;
