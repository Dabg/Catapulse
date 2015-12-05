use utf8;
package Catapulse::Web::Controller::Page;

use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

use Catapulse::Web::Form::Page::Edit;

=head1 NAME

Catapulse::Controller::Page - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=cut

=head1 METHODS

=cut

=head2 index

Redirect to '/page/list'

=cut

sub index
:Path :Args(0)
{
    my ( $self, $c ) = @_;
    $c->res->redirect('/page/list');
    $c->detach;
}

sub pages : Chained('/') PathPart('page') CaptureArgs(0) {
    my ($self, $c) = @_;

    my $current_page = $c->req->param('page') || 1;
    my $per_page     = $c->config->{per_page}->{page} ? $c->config->{per_page}->{page} : 10;

    # Type = 1 => Exclude page with 'from_controller' for type
    #my $query_search = { -not => { type => 1} };
    my $query_search = { };

    my $pages;
    if ( $c->req->param('q')){
      $pages = $c->model('DBIC::Page')->search({
                       name => { like => '%'.$c->req->param('q').'%'}},
                       {
                         order_by => \'name ASC',
                         rows     => $per_page,
                         page     => $current_page,
                       }
                     );
    }
    else {
      $pages  = $c->model('DBIC::Page')->search(
                           $query_search,
                           {
                             order_by => \'name ASC',
                             rows     => $per_page,
                             page     => $current_page,
                           });
    }

    # Pager
    my $pager          = $pages->pager;
    $c->stash->{pages} = $pages;
    $c->stash->{pager} = $pager;
  }

=head2 list

List pages

=cut

sub list : Chained('pages') Args(0) {
    my ($self, $c) = @_;
    $c->stash->{template} = 'page/list.tt';
  }


sub item : Chained('pages') PathPart('') CaptureArgs(1) {
    my ($self, $c, $id) = @_;
    $c->error("ID isn't valid!") unless $id =~ /^\d+$/;
    $c->stash->{item} = $c->stash->{pages}->find($id)
        || $c->detach('not_found');
  }

=head2 add

Suggest add page

=cut

sub add : Chained('pages') Args(0) {
    my ($self, $c) = @_;

    my $path = $c->req->param('path');

    if ( $path !~ /^[\/\.\w_\-]+$/) {
      $c->add_message( error => "Path does not match !" );
      $c->redirect_to_action('Root', 'default');
    }

    $c->stash->{path} = $path;

    my $pages = $c->model('DBIC::Page')->build_pages_from_path($path, 2);
    $c->stash->{item} = $$pages[-1];

    $c->forward('save');
}



=head2 edit

Edit page

=cut

sub edit : Chained('item') {
    my ($self, $c) = @_;
    $c->forward('save');
}

=head2 save

Save page

=cut

sub save : Private {
    my ($self, $c) = @_;

    my $form = Catapulse::Web::Form::Page::Edit->new(
                  ctx => $c,
                  item       => $c->stash->{item},
                  field_list => [ 'submit' => { type => 'Submit',
                                                value => $c->action =~ 'edit$' ? $c->loc('Update')
                                                                               : $c->loc('Create'),
                                                element_class => ['btn']
                                              }
                                ],
                  );

    $c->stash( form => $form, template => 'page/form.tt' );

    # Clean the parameter fields.
    # Else params fields are from POST and GET => ARRAY
    my $params;
    if ( $c->stash->{item} ) {
      $params = $c->req->params;
      foreach my $k ( keys %$params ) {
        if ( ref($params->{$k}) eq 'ARRAY'){
          $params->{$k} = $params->{$k}[0];
        }
      }
    }
    else {
      $params = $c->req->body_parameters;
    }

    # the "process" call has all the saving logic,
    #   if it returns False, then a validation error happened
    return unless $form->process( params => $params );

    my $up_or_sav = $c->action =~ 'edit$' ? $c->loc('updated')
                                          : $c->loc('saved');
    $c->stash->{template} = 'page/form.tt';
    $c->add_message( success => "Page " . $c->stash->{item}->name . " $up_or_sav" );

    $c->res->redirect($c->stash->{path} . '/+edit');
}


=head2 del

Delete page

=cut
sub del : Chained('item') :PathPart('del') Args(0)
{
    my ( $self, $c ) = @_;

    $c->stash->{item}->delete;
    $c->add_message( success => $c->loc('Page') . $c->stash->{item}->name  . $c->loc('deleted') );
}

=head2 permission

Page Permissions

=cut

sub permission : Chained('item') :PathPart('permission') Args(0){
  my ($self, $c) = @_;

  # check permissions
  $c->res->redirect('/access_denied')
    if !  $c->can_access([ $c->stash->{item} ], [ 'permission' ] );

  $c->stash->{roles}       = [ $c->model('DBIC::Role')->search( {}, { order_by => \'name ASC' } ) ];
  $c->stash->{operations}  = [ $c->model('DBIC::Operation')->search( {}, { order_by => \'name ASC' } ) ];
}

=head1 not_found

Item not found

=cut
sub not_found : Local {
    my ($self, $c) = @_;
    $c->add_message( error => $c->loc("Page not found") );
    $c->stash->{template} = 'not_found.tt';
    return $c->res->status(404);
}

=head1 togle_active

Toggle the active flag of a page

=cut
sub toggle_active : PathPart( 'toggle' ) Chained( 'item' ) Args( 0 ) {
    my ( $self, $c ) = @_;
    my $page = $c->stash->{item};
    if ( $page->active ) {
        $page->deactivate;
    }
    else {
        $page->activate;
    }
}

=head2 multi_action_redispatch

Try to exec allowed multi-page actions on the requested action.

When no actions catch the request, this action will try to exec
the action mapped from $allow_multi on the page_name's param  received.

=cut
has 'allow_multi' => (
    is  => 'ro',
    isa => 'HashRef',
    default => sub {{
        toggle => 'toggle_active',
        delete => 'del',
    }}
);

sub multi_action_redispatch : PathPart( 'page' ) Chained( '' ) Args( 1 ) {
    my ( $self, $c, $action ) = @_;

    if ( exists $self->allow_multi->{$action} ) {
        for my $page_name ( $c->req->param('page_name') ) {
            if ( $c->stash->{item} = $c->model('DBIC::Page')->find( $page_name ) ) {
                $c->forward( $self->allow_multi->{$action} );
            }
            else {
                $c->add_message( error => "Can't find page '$page_name'." );
            }
        }
    }
    else {
        $c->add_message( error => "Action '$action' is not defined." );
    }

    $c->redirect_to_action('Page', 'list');
}


=head1 AUTHOR

Daniel Brosseau <dab@catapulse.org>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
