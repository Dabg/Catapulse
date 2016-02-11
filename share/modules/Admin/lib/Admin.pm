package Admin;

use Moose;
use DateTime;
use Catapulse::Schema::Utils qw(add_user);

my $default_user = $ENV{USER} || 'unknown';

my $admin = {
           username => 'admin',
           password => 'admin',
           name     => $default_user,
           created  => DateTime->now,
           email     => "$default_user\@localhost",
           tzone    => 'Europe/Paris',
           website  => undef,
           active   => 1,
         };

my $anonymous = {
           username => 'anonymous',
           password => 'bla',
           name     => 'Anonymous',
           created  => DateTime->now,
           email    => 'anonymous@localhost',
           tzone    => '',
           website  => undef,
           active   => 1,
         };

sub install {
    my ($self, $module, $mi) = @_;

    my $schema = $mi->ctx->model->schema;

    # Add admin and anonymous users (and roles)
    add_user( $schema, $admin,     [ 'admin'    ] );
    add_user( $schema, $anonymous, [ 'anonymous'] );
}

sub uninstall {
    my ($self, $module, $mi) = @_;

    my $schema = $mi->ctx->model->schema;

    # delete admin and anonymous users (and roles)
    del_user( $schema, $admin,     [ 'admin'    ] );
    del_user( $schema, $anonymous, [ 'anonymous'] );
}

1;
