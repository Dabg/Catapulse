package Catapulse::Web;

use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.80;

use Catalyst qw /
    ConfigLoader
    Static::Simple
    Session
    Session::State::Cookie
    Session::Store::File
    +CatalystX::Inject
    Authentication
/;

extends 'Catalyst';

__PACKAGE__->config(
    name => 'Catapulse::Web',
    # Disable deprecated behavior needed by old applications
    disable_component_resolution_regex_fallback => 1,
    enable_catalyst_header => 1, # Send X-Catalyst header
    'Plugin::ConfigLoader' => {
        file => __PACKAGE__->path_to('share', 'etc'),
    },
);

# Start the application
__PACKAGE__->setup();

=encoding utf8

=head1 NAME

Catapulse::Web - Catalyst based CMS

=head1 SYNOPSIS

    script/catapulse_server.pl

=head1 DESCRIPTION


=head1 SEE ALSO

L<Catapulse::Web::Controller::Root>, L<Catalyst>

=head1 AUTHOR

dab,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
