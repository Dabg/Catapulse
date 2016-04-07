use utf8;
package Catapulse::Web::Controller::Page::Permission;

use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

Catapulse::Controller::Page::Permission - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=cut

=head1 METHODS

=cut

=head2 auto

run at begin (page/permission)

=cut

sub auto :Private {
    my ($self, $c) = @_;

    $c->assets->include("static/css/bootstrap-table-header-rotated.css");
    $c->assets->include("static/js/permissionEditor.js");
    $c->assets->include("static/css/3states.css");
    $c->assets->include("static/js/3states.js");
}

=head2 index

To list and change permissions

=cut

sub index :Path :Args(0){
  my ( $self, $c ) = @_;

  $c->stash->{template}    = 'page/permission.tt';

  # Should not be used directly
  if ( $c->stash->{path} eq '/page/permission' ){
    $c->res->redirect('/access_denied');
  }

  $c->res->redirect('/access_denied')
    if !  $c->can_access([ $c->stash->{page} ], [ 'permission' ] );

  if ( $c->stash->{action} eq 'permission' ){ #$c->req->param('action') && $c->req->param('action') eq 'edit' ){
    # check permissions

    $c->stash->{roles}       = [ $c->model('DBIC::Role')->search( {}, { order_by => \'name ASC' } ) ];
    $c->stash->{operations}  = [ $c->model('DBIC::Operation')->search( {} ) ];
  }
}


=head1 AUTHOR

Daniel Brosseau <dab@catapulse.org>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
