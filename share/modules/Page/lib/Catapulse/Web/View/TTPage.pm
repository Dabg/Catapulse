package Catapulse::Web::View::TTPage;

use Moose;
use namespace::autoclean;
use Template::Stash::ForceUTF8;

extends 'Catalyst::View::TT';

__PACKAGE__->config({
    INCLUDE_PATH => [
        Catapulse::Web->path_to( 'root', 'src' ),
        Catapulse::Web->path_to( 'root', 'lib' ),
    ],
    PRE_PROCESS  => 'config/main',
    WRAPPER      => 'site/wrapper2',
    TIMER        => 0,
    TEMPLATE_EXTENSION => '.tt',
#    COMPILE_DIR => '/tmp/catapulse_ttc',
    render_die   => 1,
    STASH => Template::Stash::ForceUTF8->new,
    ENCODING => 'utf-8',
    DEFAULT_ENCODING    => 'utf-8',
    PROVIDERS => [
                  {
            name    => 'Encoding',
            copy_config => [qw(DEFAULT_ENCODING INCLUDE_PATH)]
                  }
                 ]
});



=head1 NAME

MyApp::View::TT - Catalyst TTSite View

=head1 SYNOPSIS

See L<MyApp>

=head1 DESCRIPTION

Catalyst TTSite View.

=head1 AUTHOR

Daniel Brosseau <dab@catapulse.org>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
