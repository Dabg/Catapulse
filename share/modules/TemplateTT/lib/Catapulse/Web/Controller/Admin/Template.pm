use utf8;
package Catapulse::Web::Controller::Admin::Template;

use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

use Catapulse::Web::Form::Template::Edit;

=head1 NAME

MyApp::Controller::Admin::Template - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=cut

=head1 METHODS

=cut

=head2 index

Redirect to '/admin/template/list'

=cut

sub index
:Path :Args(0)
{
    my ( $self, $c ) = @_;
    $c->res->redirect('/admin/template/list');
    $c->detach;
}


sub templates : Chained('/') PathPart('admin/template') CaptureArgs(0) {
    my ($self, $c) = @_;

    my $current_page = $c->req->param('page') || 1;
    my $per_page     = $c->config->{per_page}->{template} ? $c->config->{per_page}->{template} : 10;
    my $templates        = $c->model('DBIC::Template')->search(
                                                       {},
                                                       {
                                                        order_by => \'name ASC',
                                                        rows     => $per_page,
                                                        page     => $current_page,
                                                       }
                                                      );
    # Pager
    my $pager          = $templates->pager;
    $c->stash->{templates} = $templates;
    $c->stash->{pager} = $pager;
  }

=head2 list

List templates

=cut

sub list : Chained('templates') Args(0) {
    my ($self, $c) = @_;
    $c->stash->{template} = 'admin/template/list.tt';
}

sub item : Chained('templates') PathPart('') CaptureArgs(1) {
    my ($self, $c, $id) = @_;

    $c->error("ID isn't valid!") unless $id =~ /^\d+$/;
    $c->stash->{item} = $c->stash->{templates}->find($id)
        || $c->detach('not_found');
}

=head2 add

Add template

=cut

sub add : Chained('templates') Args(0) {
    my ($self, $c) = @_;
    $c->stash->{item} = $c->model('DBIC::Template')->new_result({});
    $c->forward('save');
}

=head2 edit

Edit template

=cut

sub edit : Chained('item') {
    my ($self, $c) = @_;
    $c->forward('save');
}

=head2 save

Save template

=cut

sub save : Private {
    my ($self, $c) = @_;

    my $form = Catapulse::Web::Form::Template::Edit->new(
                  ctx => $c,
                  item       => $c->stash->{item},
                  field_list => [ 'submit' => { type => 'Submit',
                                                value => $c->action =~ 'edit$' ? $c->loc('Update')
                                                                               : $c->loc('Create'),
                                                element_class => ['btn']
                                              }
                                ],
                  );

    $c->stash( form => $form, template => 'admin/template/form.tt' );

    # the "process" call has all the saving logic,
    #   if it returns False, then a validation error happened
    return unless $form->process( params => $c->req->params  );

    my $up_or_sav = $c->action =~ 'edit$' ? $c->loc('updated')
                                          : $c->loc('saved');
    $c->stash->{template} = 'admin/template/form.tt';
    $c->add_message( success => "Template " . $c->stash->{item}->name . " $up_or_sav" );

    $c->redirect_to_action('Admin::Template', 'list');
}


=head2 del

Delete template

=cut
sub del : Chained('item') :PathPart('del') Args(0)
{
    my ( $self, $c ) = @_;

    my $name = $c->stash->{item}->name;
    $c->stash->{item}->delete;
    $c->add_message( success => $c->loc('Template') . " '$name' " . $c->loc('deleted') );
}

=head1 not_found

Item not found

=cut
sub not_found : Local {
    my ($self, $c) = @_;
    $c->add_message( error => "Template not found" );
    $c->stash->{template} = 'not_found.tt';
    return $c->res->status(404);
}

=head1 togle_active

Toggle the active flag of a template

=cut
sub toggle_active : PathPart( 'toggle' ) Chained( 'item' ) Args( 0 ) {
    my ( $self, $c ) = @_;
    my $template = $c->stash->{item};
    if ( $template->active ) {
        $template->deactivate;
    }
    else {
        $template->activate;
    }
}

=head2 multi_action_redispatch

Try to exec allowed multi-template actions on the requested action.

When no actions catch the request, this action will try to exec
the action mapped from $allow_multi on the template_name's param  received.

=cut
has 'allow_multi' => (
    is  => 'ro',
    isa => 'HashRef',
    default => sub {{
        toggle => 'toggle_active',
        delete => 'del',
    }}
);

sub multi_action_redispatch : PathPart( 'admin/template' ) Chained( '' ) Args( 1 ) {
    my ( $self, $c, $action ) = @_;

    if ( exists $self->allow_multi->{$action} ) {
        for my $template_name ( $c->req->param('template_name') ) {
            if ( $c->stash->{item} = $c->model('DBIC::Template')->find( $template_name ) ) {
                $c->forward( $self->allow_multi->{$action} );
            }
            else {
                $c->add_message( error => "Can't find template '$template_name'." );
            }
        }
    }
    else {
        $c->add_message( error => "Action '$action' is not defined." );
    }

    $c->redirect_to_action('Admin::Template', 'list');
}


=head1 AUTHOR

Daniel Brosseau <dab@catapulse.org>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
