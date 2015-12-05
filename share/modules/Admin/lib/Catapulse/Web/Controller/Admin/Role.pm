use utf8;
package Catapulse::Web::Controller::Admin::Role;

use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

use Catapulse::Web::Form::Role::Edit;

=head1 NAME

MyApp::Controller::Admin::Role - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=cut

=head1 METHODS

=cut

=head2 index

Redirect to '/admin/role/list'

=cut

sub index
:Path :Args(0)
{
    my ( $self, $c ) = @_;
    $c->res->redirect('/admin/role/list');
    $c->detach;
}


sub roles : Chained('/') PathPart('admin/role') CaptureArgs(0) {
    my ($self, $c) = @_;

    my $current_page = $c->req->param('page') || 1;
    my $per_page     = $c->config->{per_page}->{role} ? $c->config->{per_page}->{role} : 10;
    my $roles        = $c->model('DBIC::Role')->search(
                                                       {},
                                                       {
                                                        order_by => \'name ASC',
                                                        rows     => $per_page,
                                                        page     => $current_page,
                                                       }
                                                      );
    # Pager
    my $pager          = $roles->pager;
    $c->stash->{roles} = $roles;
    $c->stash->{pager} = $pager;
  }

=head2 list

List roles

=cut

sub list : Chained('roles') Args(0) {
    my ($self, $c) = @_;
    $c->stash->{template} = 'admin/role/list.tt';
}

sub item : Chained('roles') PathPart('') CaptureArgs(1) {
    my ($self, $c, $id) = @_;

    $c->error("ID isn't valid!") unless $id =~ /^\d+$/;
    $c->stash->{item} = $c->stash->{roles}->find($id)
        || $c->detach('not_found');
}

=head2 add

Add role

=cut

sub add : Chained('roles') Args(0) {
    my ($self, $c) = @_;
    $c->stash->{item} = $c->model('DBIC::Role')->new_result({});
    $c->forward('save');
}

=head2 edit

Edit role

=cut

sub edit : Chained('item') {
    my ($self, $c) = @_;
    $c->forward('save');
}

=head2 save

Save role

=cut

sub save : Private {
    my ($self, $c) = @_;

    my $form = Catapulse::Web::Form::Role::Edit->new(
                  ctx => $c,
                  item       => $c->stash->{item},
                  field_list => [ 'submit' => { type => 'Submit',
                                                value => $c->action =~ 'edit$' ? $c->loc('Update')
                                                                               : $c->loc('Create'),
                                                element_class => ['btn']
                                              }
                                ],
                  );

    $c->stash( form => $form, template => 'admin/role/form.tt' );

    # the "process" call has all the saving logic,
    #   if it returns False, then a validation error happened
    return unless $form->process( params => $c->req->params  );

    my $up_or_sav = $c->action =~ 'edit$' ? $c->loc('updated')
                                          : $c->loc('saved');
    $c->stash->{template} = 'admin/role/form.tt';
    $c->add_message( success => "Role " . $c->stash->{item}->name . " $up_or_sav" );

    $c->redirect_to_action('Admin::Role', 'list');
}


=head2 del

Delete role

=cut
sub del : Chained('item') :PathPart('del') Args(0)
{
    my ( $self, $c ) = @_;

    my $name = $c->stash->{item}->name;
    $c->stash->{item}->delete;
    $c->add_message( success => $c->loc('Role') . " '$name' " . $c->loc('deleted') );
}

=head1 not_found

Item not found

=cut
sub not_found : Local {
    my ($self, $c) = @_;
    $c->add_message( error => "Role not found" );
    $c->stash->{template} = 'not_found.tt';
    return $c->res->status(404);
}

=head1 togle_active

Toggle the active flag of a role

=cut
sub toggle_active : PathPart( 'toggle' ) Chained( 'item' ) Args( 0 ) {
    my ( $self, $c ) = @_;
    my $role = $c->stash->{item};
    if ( $role->active ) {
        $role->deactivate;
    }
    else {
        $role->activate;
    }
}

=head2 multi_action_redispatch

Try to exec allowed multi-role actions on the requested action.

When no actions catch the request, this action will try to exec
the action mapped from $allow_multi on the role_name's param  received.

=cut
has 'allow_multi' => (
    is  => 'ro',
    isa => 'HashRef',
    default => sub {{
        toggle => 'toggle_active',
        delete => 'del',
    }}
);

sub multi_action_redispatch : PathPart( 'admin/role' ) Chained( '' ) Args( 1 ) {
    my ( $self, $c, $action ) = @_;

    if ( exists $self->allow_multi->{$action} ) {
        for my $role_name ( $c->req->param('role_name') ) {
            if ( $c->stash->{item} = $c->model('DBIC::Role')->find( $role_name ) ) {
                $c->forward( $self->allow_multi->{$action} );
            }
            else {
                $c->add_message( error => "Can't find role '$role_name'." );
            }
        }
    }
    else {
        $c->add_message( error => "Action '$action' is not defined." );
    }

    $c->redirect_to_action('Admin::Role', 'list');
}


=head1 AUTHOR

Daniel Brosseau <dab@catapulse.org>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
