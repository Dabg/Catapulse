use utf8;
package Catapulse::Web;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.80;

use Catalyst qw/
    ConfigLoader
    I18N
    +CatalystX::InjectModule
    Authentication
    Session
    Session::State::Cookie
    Session::Store::File
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

__PACKAGE__->config->{session} = {
    expires        => 3600,
    flash_to_stash => 1,
};


# Start the application
__PACKAGE__->setup();


sub pref {
    my ( $c, $setting, $value ) = @_;

    return unless $setting;

    my $result = {
        anonymous_id     => 2,
        anonymous_user   => 'Anonymous',
        enable_emoticons => 0,
        default_lang     => 'en',
        main_formatter   => 'Catapulse::Formatter::Markdown',
    };

    die "Error : Setting $setting is unknown !!!" if ! defined $result->{$setting};
    return $result->{$setting};
}


=head1 add_message

Add messages

Log to developer in debug mode!

=cut
sub add_message {
    my ( $c, $type, $message ) = @_;

    unless ( defined $type && defined $message ) {
        warn 'Bad usage of add_message()';
        return 0;
    }

    push @{ $c->flash->{feedback}{$type} }, $message;
    $c->log->debug( $type . ': ' . $message ) if $c->debug;

    return 1;
}

=encoding utf8

=head1 NAME

Catapulse::Web - Catalyst based CMS

=head1 SYNOPSIS

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
