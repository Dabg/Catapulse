package UserRole;

use Moose;

with 'Catapulse::Schema::Utils';

my $default_user = $ENV{USER} || 'unknown';

my $admin = {
           username => 'admin',
           password => 'admin',
           name     => $default_user,
           email     => "$default_user\@localhost",
           tzone    => 'Europe/Paris',
           active   => 1,
         };

my $anonymous = {
           username => 'anonymous',
           password => 'bla',
           name     => 'Anonymous',
           email    => 'anonymous@localhost',
           tzone    => '',
           active   => 1,
         };

sub install {
    my ($self, $module) = @_;

    # Add admin and anonymous users (and roles)
    $self->foc_user( $admin,     [ 'admin'    ] );
    $self->foc_user( $anonymous, [ 'anonymous'] );
}

sub uninstall {
    my ($self, $module) = @_;

    # delete admin and anonymous users (and roles)
    $self->del_user( $admin,     [ 'admin'    ] );
    $self->del_user( $anonymous, [ 'anonymous'] );
}

1;
