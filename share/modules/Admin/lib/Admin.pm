package Admin;

use Moose;
#with 'Catapulse::Module';
with 'CatalystX::InjectModule::Fixture';

sub install {
    my ($self, $module, $mi) = @_;

    $self->install_fixtures($module, $mi);
}

1;
