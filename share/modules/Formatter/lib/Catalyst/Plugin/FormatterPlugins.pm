package Catalyst::Plugin::FormatterPlugins;

=head1 NAME

Catalyst::Plugin::Page

=cut

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

=head1 SEE ALSO

L<Catalyst>.

=head1 AUTHORS

Daniel Brosseau, 2016, <dab@catapulse.org>

=head1 LICENSE

This library is free software . You can redistribute it and/or modify
it under the same terms as perl itself.

=cut

1;
