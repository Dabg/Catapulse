package Admin;

use Moose;
with 'Catapulse::Module';

sub install {
    my ($self, $module, $mi) = @_;

    $self->install_fixtures($module, $mi);
}

1;
