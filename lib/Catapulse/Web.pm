use utf8;
package Catapulse::Web;

use Moose;
use namespace::autoclean;

extends 'Catalyst';


use Catalyst qw /
    ConfigLoader
    +CatalystX::Inject
    Authentication
    I18N
/;

extends 'Catalyst';

__PACKAGE__->config(
    name => 'Catapulse::Web',
    # Disable deprecated behavior needed by old applications
    disable_component_resolution_regex_fallback => 1,
    enable_catalyst_header => 1, # Send X-Catalyst header
    # 'Plugin::ConfigLoader' => {
    #     file => __PACKAGE__->path_to('share', 'etc'),
    # },
    # Disable X-Catalyst header
    enable_catalyst_header => 0,
);

# Start the application
__PACKAGE__->setup();

=encoding utf8

=head1 NAME

Catapulse::Web - Catalyst based CMS

=head1 SYNOPSIS

    # use autocreated database  share/catapulse-schema.db
    script/catapulse_server.pl

    # or another DBIX dsn in share/etc/catapulse_web.yml
    # and populate this database

    # change Database Model in share/etc/catapulse_web.yml
    # - Database Model -
    Model::DBIC:
     schema_class: Catapulse::Schema
     connect_info:
       dsn: dbi:mysql:database=catapulse;host=localhost
       user: dbadmin
       password: secret

    # Populate database
    ./script/manage_db.pl install
    ./script/manage_db.pl populate
    [ ./script/manage_db.pl help]

    # Start standalone server
    ./script/catapulse_web.pl

    # Go to http://localhost:3000

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
