package Catapulse::Module;

use Moose;

has mi => (
              is       => 'rw',
              isa      => 'CatalystX::InjectModule::MI',
          );

1;
