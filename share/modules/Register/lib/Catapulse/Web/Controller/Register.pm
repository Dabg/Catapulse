package Catapulse::Web::Controller::Register;

# It's a copy of Bracket::Controller::Register
use Moose;
BEGIN { extends 'Catalyst::Controller' }
use Catapulse::Web::Form::Register;

=head1 Name

Catapulse::Web::Controller::Register - Functions for registration

=head1 Description

Controller with register related actions:

* index
* change/reset password

=cut


sub register : Global {
    my ($self, $c) = @_;

    my $form = Catapulse::Web::Form::Register->new (
        ctx => $c,
    );

    $c->stash(
        template => 'form/register/index.tt',
        form     => $form,
    );

    my $new_user = $c->model('DBIC::User')->new_result({});
    $form->process(
        item   => $new_user,
        params => $c->request->parameters,
    );

    # This return on GET (new form) and a POSTed form that's invalid.
    return if !$form->is_valid;

    # At this stage the form has validated
    $c->flash->{status_msg} = 'Registration succeeded';
    $c->response->redirect($c->uri_for('/login'));
}



1
