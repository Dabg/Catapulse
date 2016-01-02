package Catapulse::Web::Block;

use Moose;
use namespace::autoclean;
use MooseX::Types::LoadableClass qw/ClassName/;


has ctx   =>  (is => 'rw',
#               isa => 'Catapulse::Web',
              );

has class   =>  (is => 'rw',
                isa => ClassName,
                coerce => 1
              );

1;
