package UserRole;

=head1 NAME

UserRole - UserRole module

=cut

use Moose;

with 'Catapulse::Schema::Utils';

my $default_user = $ENV{USER} || 'unknown';

my $admin = {
           username => 'admin',
           password => 'admin',
           name     => $default_user,
           email     => "$default_user\@localhost",
           tzone    => 'Europe/Paris',
           active   => 1,
         };

my $anonymous = {
           username => 'anonymous',
           password => 'bla',
           name     => 'Anonymous',
           email    => 'anonymous@localhost',
           tzone    => '',
           active   => 1,
         };

my $admin_role = {
           name => 'admin',
           active   => 1,
};

my $anonymous_role = {
           name => 'anonymous',
           active   => 1,
};

=head2 install

module installer

=cut

sub install {
    my ($self, $module) = @_;

    # Add admin and anonymous users (and roles)
    $self->foc_user( $admin,     [ 'admin'    ] );
    $self->foc_user( $anonymous, [ 'anonymous'] );
}

=head2 uninstall

module uninstaller

=cut

sub uninstall {
    my ($self, $module, $mi) = @_;

    # delete admin and anonymous users (and roles)
    $self->del_user( $admin );
    $self->del_user( $anonymous );
    $self->del_role( $anonymous_role );
    $self->del_role( $admin_role );
}

=head1 SEE ALSO

L<Catapulse>

=head1 AUTHOR

Daniel Brosseau, 2016, <dab@catapulse.org>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
