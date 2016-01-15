package Admin;

use Moose;
use Authen::Passphrase::BlowfishCrypt;
use DateTime;

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

    # Add admin and anonymous users
    my $u1 = $schema->resultset('User')->find_or_create($admin);
    my $u2 = $schema->resultset('User')->find_or_create($anonymous);

    # Add role admin to Admin and role anonymous to Anonymous
    $u1->add_to_roles( { name => 'admin'     } );
    $u2->add_to_roles( { name => 'anonymous' } );
}

sub uninstall {
    my ($self, $module, $mi) = @_;

     my $schema = $mi->ctx->model->schema;

    # Delete admin and anonymous users
    $schema->resultset('User')->search( { username => 'admin'     })->delete_all;
    $schema->resultset('User')->search( { username => 'anonymous' })->delete_all;

    # Delete admin and anonymous roles
    $schema->resultset('Role')->search( { name => 'admin'     })->delete_all;
    $schema->resultset('Role')->search( { name => 'anonymous' })->delete_all;
}

1;
