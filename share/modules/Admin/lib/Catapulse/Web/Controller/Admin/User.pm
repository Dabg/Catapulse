use utf8;
package Catapulse::Web::Controller::Admin::User;

use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

use Catapulse::Web::Form::User::Edit;

=head1 NAME

MyApp::Controller::Admin::User - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=cut

=head1 ATTRIBUTS

=head2 edit_form

Use Catapulse::Web::Form::Action::Edit as Form

=cut

has 'edit_form' => ( isa => 'Catapulse::Web::Form::User::Edit', is => 'rw',
        lazy => 1, default => sub { Catapulse::Web::Form::User::Edit->new } );

=head1 METHODS

=cut

=head2 index

Redirect to '/admin/user/list'

=cut

sub index
:Path :Args(0)
{
    my ( $self, $c ) = @_;
    $c->res->redirect('/admin/user/list');
    $c->detach;
}


sub users : Chained('/') PathPart('admin/user') CaptureArgs(0) {
    my ($self, $c) = @_;

    my $current_page = $c->req->param('page') || 1;
    my $per_page     = $c->config->{per_page}->{user} ? $c->config->{per_page}->{user} : 10;
    my $users        = $c->model('DBIC::User')->search(
                                                       {},
                                                       {
                                                        order_by => \'username ASC',
                                                        rows     => $per_page,
                                                        page     => $current_page,
                                                       }
                                                      );
    # Pager
    my $pager          = $users->pager;
    $c->stash->{users} = $users;
    $c->stash->{pager} = $pager;
  }

=head2 list

List users

=cut

sub list : Chained('users') Args(0) {
    my ($self, $c) = @_;
    $c->stash->{template} = 'admin/user/list.tt';
}

sub item : Chained('users') PathPart('') CaptureArgs(1) {
    my ($self, $c, $id) = @_;
    $c->error("ID isn't valid!") unless $id =~ /^\d+$/;
    $c->stash->{item} = $c->stash->{users}->find($id)
        || $c->detach('not_found');
}

=head2 add

Add user

=cut

sub add : Chained('users') Args(0) {
    my ($self, $c) = @_;
    $c->stash->{item} = $c->model('DBIC::User')->new_result({});
    $c->forward('save');
}

=head2 edit

Edit user

=cut

sub edit : Chained('item') {
    my ($self, $c) = @_;
    $c->forward('save');
}

=head2 save

Save user

=cut

sub save : Private {
    my ($self, $c) = @_;

    my $form = Catapulse::Web::Form::User::Edit->new(
                  ctx => $c,
                  item       => $c->stash->{item},
                  field_list => [ 'submit' => { type => 'Submit',
                                                value => $c->action =~ 'edit$' ? $c->loc('Update')
                                                                               : $c->loc('Create'),
                                                element_class => ['btn']
                                              }
                                ],
                  );

    $c->stash( form => $form, template => 'admin/user/form.tt' );

    # the "process" call has all the saving logic,
    #   if it returns False, then a validation error happened
    return unless $form->process( params => $c->req->params );

    my $up_or_sav = $c->action =~ 'edit$' ? $c->loc('updated')
                                          : $c->loc('saved');

    $c->stash->{template} = 'admin/user/form.tt';
    $c->add_message( success => "User " . $c->stash->{item}->username . " $up_or_sav" );

    $c->res->redirect($c->uri_for("/admin/user/list"));
    $c->detach;
  }

=head2 del

Delete user

=cut
sub del : Chained('item') :PathPart('del') Args(0)
{
    my ( $self, $c ) = @_;

    my $name = $c->stash->{item}->username;
    $c->stash->{item}->delete;
    $c->add_message( success => $c->loc('User') . " '$name' " . $c->loc('deleted') );
}

=head1 not_found

Item not found

=cut
sub not_found : Local {
    my ($self, $c) = @_;
    $c->add_message( error => "User not found" );
    $c->stash->{template} = 'not_found.tt';
    return $c->res->status(404);
}

=head1 togle_active

Toggle the active flag of a user

=cut
sub toggle_active : PathPart( 'toggle' ) Chained( 'item' ) Args( 0 ) {
    my ( $self, $c ) = @_;
    my $user = $c->stash->{item};
    if ( $user->active ) {
        $user->deactivate;
    }
    else {
        $user->activate;
    }
}

=head2 multi_action_redispatch

Try to exec allowed multi-user actions on the requested action.

When no actions catch the request, this action will try to exec
the action mapped from $allow_multi on the user_name's param  received.

=cut
has 'allow_multi' => (
    is  => 'ro',
    isa => 'HashRef',
    default => sub {{
        toggle => 'toggle_active',
        delete => 'del',
    }}
);

sub multi_action_redispatch : PathPart( 'admin/user' ) Chained( '' ) Args( 1 ) {
    my ( $self, $c, $action ) = @_;

    if ( exists $self->allow_multi->{$action} ) {
        for my $user_name ( $c->req->param('user_name') ) {
            if ( $c->stash->{item} = $c->model('DBIC::User')->find( $user_name ) ) {
                $c->forward( $self->allow_multi->{$action} );
            }
            else {
                $c->add_message( error => "Can't find user '$user_name'." );
            }
        }
    }
    else {
        $c->add_message( error => "Action '$action' is not defined." );
    }

    $c->redirect_to_action('Admin::User', 'list');
}


=head1 AUTHOR

Daniel Brosseau <dab@catapulse.org>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
