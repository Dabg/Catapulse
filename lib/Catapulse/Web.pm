use utf8;
package Catapulse::Web;

=encoding utf8

=head1 NAME

Catapulse::Web - Catalyst based CMS

=cut

use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.80;
use Term::ANSIColor qw(:constants);

=head1 SYNOPSIS

    # use the database self created
    ./script/catapulse_web.pl

    # OR change Database Model in share/etc/catapulse_web.yml
    # - Database Model -
    Model::DBIC:
     schema_class: Catapulse::Schema
     connect_info:
       dsn: dbi:mysql:database=catapulse;host=localhost
       user: dbadmin
       password: secret

    # Deploy database
    ./script/catapulse_spawn.pl

    # Start standalone server
    # ( populate database the first time )
    ./script/catapulse_web.pl

    # Go to http://localhost:3000

=head1 DESCRIPTION

=cut

use Catalyst qw/
    Assets
    ConfigLoader
    I18N
    Cache
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
    # 'Plugin::ConfigLoader' => {
    #     file => __PACKAGE__->path_to('share', 'etc'),
    # },
    # Disable X-Catalyst header
    enable_catalyst_header => 0,

    'Plugin::Cache' => {
      'backend' => {
          'class' => 'Cache::FileCache',
          'cache_root' => "./cache",
          'namespace' =>  "default",
          'default_expires_in' =>'8 hours',
          'auto_remove_stale' => 1,
          'debug' =>  2,
      },
                     }
);

__PACKAGE__->config->{session} = {
    expires        => 3600,
    flash_to_stash => 1,
};


# Start the application
__PACKAGE__->setup();

=head2 pref

=cut
sub pref {
    my ( $c, $setting, $value ) = @_;

    return unless $setting;

    my $pref = $c->config->{preferences};
    die "Error : Setting $setting is unknown !!!" if ! defined $pref->{$setting};

    return $pref->{$setting};
}

=head2 add_message

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

=head2 uri_for_static

=cut
sub uri_for_static {
    my ( $self, $asset ) = @_;
     return
        ( defined($self->config->{static_path} )
     ?  $self->config->{static_path} . $asset
     :  $self->uri_for('/static', $asset) );
}


=head2 tz

Convert timezone

=cut

sub tz {
  my ($c, $dt) = @_;
  if ($c->user && $c->user->timezone) {
    eval { $dt->set_time_zone($c->user->timezone) };
  }
  return $dt;
}


=head2 trace

=cut
sub trace {
    my($self, $msg) = @_;

    #if ( $self->debug > 1){
        my $caller = ( caller(1) )[3];
        $msg = YELLOW.BOLD.$caller.CLEAR.' '.$msg;
        $self->log->debug( RED." TRACE".CLEAR.": $msg" );
    #}

}


=head1 SEE ALSO

L<Catalyst>

=head1 AUTHOR

Daniel Brosseau, 2016, <dab@catapulse.org>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
