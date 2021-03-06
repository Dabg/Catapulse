package Debug::Controller::Debug::Config;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Debug::Controller::Debug - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->add_message( message => $c->loc('ui.page.welcome.message'));
    $c->add_message( error => $c->loc('test.error.message'));

    $c->stash(config => $c->config);
}



=encoding utf8

=head1 AUTHOR

dab,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
