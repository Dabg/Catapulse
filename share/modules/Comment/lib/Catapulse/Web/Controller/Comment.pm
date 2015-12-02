use utf8;
package Catapulse::Web::Controller::Comment;

use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

use Catapulse::Web::Form::Comment;

=head1 NAME

Catapulse::Controller::Comment - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=cut

=head1 METHODS

=cut

=head2 index

Add a comment

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    my $form      = Catapulse::Web::Form::Comment->new( ctx    => $c,
                                                        item   => $c->model('DBIC::Comment')->new_result({}) );
    my $poster_id = $c->request->body_parameters->{poster};
    my $page_id   = $c->request->body_parameters->{page};

    if ( $poster_id != $c->user->id) {
      $c->req->redirect('/access_denied');
      $c->detach;
    }

    $form->process( init_object => { posted => DateTime->now }, params => $c->request->body_parameters );
    if ( ! $form->validated ){
      use Data::Dumper;
      say STDERR "Errors: " . Dumper($form->errors);
      return;
    }
    else {
      $c->stash->{comments} =
        $c->model("DBIC::Comment")
        ->search( { page => $page_id }, { order_by => 'posted' } );
      my $comments = $c->view('TTBlock')->render( $c, 'blocks/comment.tt' );
      $c->stash->{comments} = $comments;
      return $c->res->body($comments);
    }
  }



=head2 del

Remove comments, provided user can edit the page the comment is on.

=cut

sub del : Local {
    my ( $self, $c, $comment ) = @_;

    if ( $comment = $c->model("DBIC::Comment")->find($comment) ) {
            $comment->delete();
    }
    $c->res->redirect('/');
    $c->detach;
}


=head1 AUTHOR

Daniel Brosseau <dab@catapulse.org>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
