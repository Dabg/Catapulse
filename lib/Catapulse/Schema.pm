use utf8;
package Catapulse::Schema;

use strict;
use warnings;

use base 'DBIx::Class::Schema';

__PACKAGE__->load_namespaces;


BEGIN { $ENV{DBIC_OVERWRITE_HELPER_METHODS_OK} = 1 }


our $VERSION = 1;

=head1 NAME

Catapulse::Schema - DBIC Schema

=cut

=head1 AUTHOR

Daniel Brosseau <dab@catapulse.org>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut


1;
