package Catapulse::Web::Model::DBIC;

use Moose;
extends 'Catalyst::Model::DBIC::Schema';

__PACKAGE__->config(
   ( Catapulse::Web->config->{debug}->{querylog} ) ? ( traits => ['QueryLog'] ) : (),
    on_connect_do => sub { tie %{shift->_dbh->{CachedKids}}, 'Tie::Cache', 100 },
);



=head1 NAME

Catapulse::Web::Model::DBIC - Catalyst DBIC Schema Model

=head1 SYNOPSIS

See L<Catapulse::Web>

=head1 DESCRIPTION

L<Catalyst::Model::DBIC::Schema> Model using schema L<Catapulse::Schema>

=head1 GENERATED BY

Catalyst::Helper::Model::DBIC::Schema

=head1 AUTHOR

dab

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
