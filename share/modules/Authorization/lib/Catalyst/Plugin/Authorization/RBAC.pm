use utf8;

package Catalyst::Plugin::Authorization::RBAC;


use Moose::Role;
use namespace::autoclean;
use Authorization::RBAC;

use vars qw($VERSION);
$VERSION = '0.01';

after 'setup_components' => sub {
	my $self = shift;

	$self->mk_classdata('rbac');

    $self->rbac(Authorization::RBAC->new(
        conf  => $self->config, # use Catapulse config
        schema => $self->model->schema,
    ));

    my $cache = $self->cache if ( $self->rbac->config->{cache} && defined $self->can('cache'));
    $self->rbac->cache($cache);
};


# can_access check if user or roles have permissions on all objects
# of a object or more.
sub can_access {
  my ( $self, $objects, $additional_operations ) = @_;

  my @roles = $self->user ? $self->user->user_roles : $self->stash->{anonymous_user}->roles;

  return $self->rbac->can_access( [ @roles ], $objects, $additional_operations);
}

1;

__END__

=head1 NAME

Catalyst::Plugin::Authorization::RBAC -

=head1 SYNOPSIS

    use Catalyst qw/
                     Authorization::Roles
                     Authorization::RBAC
                   /;



=head1 DESCRIPTION



=back

=head1 SEE ALSO

L<Catalyst>.

=head1 AUTHORS

Daniel Brosseau, 2015, <dab@catapulse.org>

=head1 LICENSE

This library is free software . You can redistribute it and/or modify
it under the same terms as perl itself.

=cut
