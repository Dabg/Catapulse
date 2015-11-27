use utf8;
package Catapulse::Web::Controller::Admin::Block;

use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

use Catapulse::Web::Form::Block::Edit;

=head1 NAME

MyApp::Controller::Admin::Block - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=cut

=head1 METHODS

=cut

=head2 index

Redirect to '/admin/block/list'

=cut

sub index
:Path :Args(0)
{
    my ( $self, $c ) = @_;
    $c->res->redirect('/admin/block/list');
    $c->detach;
}


sub blocks : Chained('/') PathPart('admin/block') CaptureArgs(0) {
    my ($self, $c) = @_;

    my $current_page = $c->req->param('page') || 1;
    my $per_page     = $c->config->{per_page}->{block} ? $c->config->{per_page}->{block} : 10;
    my $blocks        = $c->model('DBIC::Block')->search(
                                                       {},
                                                       {
                                                        order_by => \'name ASC',
                                                        rows     => $per_page,
                                                        page     => $current_page,
                                                       }
                                                      );
    # Pager
    my $pager          = $blocks->pager;
    $c->stash->{blocks} = $blocks;
    $c->stash->{pager} = $pager;
  }

=head2 list

List blocks

=cut

sub list : Chained('blocks') Args(0) {
    my ($self, $c) = @_;
}

sub item : Chained('blocks') PathPart('') CaptureArgs(1) {
    my ($self, $c, $id) = @_;

    $c->error("ID isn't valid!") unless $id =~ /^\d+$/;
    $c->stash->{item} = $c->stash->{blocks}->find($id)
        || $c->detach('not_found');
}

=head2 add

Add block

=cut

sub add : Chained('blocks') Args(0) {
    my ($self, $c) = @_;
    $c->stash->{item} = $c->model('DBIC::Block')->new_result({});
    $c->forward('save');
}

=head2 edit

Edit block

=cut

sub edit : Chained('item') {
    my ($self, $c) = @_;
    $c->forward('save');
}

=head2 save

Save block

=cut

sub save : Private {
    my ($self, $c) = @_;

    my $form = Catapulse::Web::Form::Block::Edit->new(
                  ctx => $c,
                  item       => $c->stash->{item},
                  field_list => [ 'submit' => { type => 'Submit',
                                                value => $c->action =~ 'edit$' ? $c->loc('Update')
                                                                               : $c->loc('Create'),
                                                element_class => ['btn']
                                              }
                                ],
                  );

    $c->stash( form => $form, template => 'admin/block/form.tt' );

    # the "process" call has all the saving logic,
    #   if it returns False, then a validation error happened
    return unless $form->process( params => $c->req->params  );

    my $up_or_sav = $c->action =~ 'edit$' ? $c->loc('updated')
                                          : $c->loc('saved');
    $c->stash->{template} = 'admin/block/form.tt';
    $c->add_message( success => "Block " . $c->stash->{item}->name . " $up_or_sav" );

    $c->redirect_to_action('Admin::Block', 'list');
}


=head2 del

Delete block

=cut
sub del : Chained('item') :PathPart('del') Args(0)
{
    my ( $self, $c ) = @_;

    my $name = $c->stash->{item}->name;
    $c->stash->{item}->delete;
    $c->add_message( success => $c->loc('Block') . " '$name' " . $c->loc('deleted') );
}

=head1 not_found

Item not found

=cut
sub not_found : Local {
    my ($self, $c) = @_;
    $c->add_message( error => "Block not found" );
    $c->stash->{template} = 'not_found.tt';
    return $c->res->status(404);
}

=head1 togle_active

Toggle the active flag of a block

=cut
sub toggle_active : PathPart( 'toggle' ) Chained( 'item' ) Args( 0 ) {
    my ( $self, $c ) = @_;
    my $block = $c->stash->{item};
    if ( $block->active ) {
        $block->deactivate;
    }
    else {
        $block->activate;
    }
}

=head2 multi_action_redispatch

Try to exec allowed multi-block actions on the requested action.

When no actions catch the request, this action will try to exec
the action mapped from $allow_multi on the block_name's param  received.

=cut
has 'allow_multi' => (
    is  => 'ro',
    isa => 'HashRef',
    default => sub {{
        toggle => 'toggle_active',
        delete => 'del',
    }}
);

sub multi_action_redispatch : PathPart( 'admin/block' ) Chained( '' ) Args( 1 ) {
    my ( $self, $c, $action ) = @_;

    if ( exists $self->allow_multi->{$action} ) {
        for my $block_name ( $c->req->param('block_name') ) {
            if ( $c->stash->{item} = $c->model('DBIC::Block')->find( $block_name ) ) {
                $c->forward( $self->allow_multi->{$action} );
            }
            else {
                $c->add_message( error => "Can't find block '$block_name'." );
            }
        }
    }
    else {
        $c->add_message( error => "Action '$action' is not defined." );
    }

    $c->redirect_to_action('Admin::Block', 'list');
}


=head1 AUTHOR

Daniel Brosseau <dab@catapulse.org>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
