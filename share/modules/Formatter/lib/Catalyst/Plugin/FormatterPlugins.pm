package Catalyst::Plugin::FormatterPlugins;

use Moose::Role;
use Catapulse::Formatter;

has formatter => ( is  => 'rw',
                   isa => 'Catapulse::Formatter',
                   lazy_build => 1,
                 );

sub _build_formatter{
  my $self = shift;

  return Catapulse::Formatter->new;
}


1;
