package Catapulse::Web::Controller::Wiki;

use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }
use Catapulse::Web::Form::Wiki;

eval {require Syntax::Highlight::Engine::Kate};
my $kate_installed = !$@;

=head1 NAME

Catapulse::Web::Controller::Wiki - Catalyst Controller

( Inspired by MojoMojo/Controller/PageAdmin.pm )

=head1 DESCRIPTION

Catalyst Controller but we use only one url (/wiki)

so we must be use parameters to dispatch actions

=head1 METHODS

=cut


sub index :Path :Args(0){
  my ( $self, $c ) = @_;

  # Should not be used directly
  if ( ! $c->stash->{page} || $c->stash->{page}->type->name ne 'wiki' ){
    $c->res->redirect('/access_denied');
  }

  if ( defined $c->stash->{action} && $c->stash->{action} eq 'edit' ){
    $c->forward('edit');
  }
}


sub edit :PathPart('edit') :Args(0) {
  my ( $self, $c ) = @_;

  # prepare the list of available syntax highlighters
  if ($kate_installed) {
    my $syntax = new Syntax::Highlight::Engine::Kate;
    # 'Alerts' is a hidden Kate module, so delete it from list
    $c->stash->{syntax_formatters} = [ grep ( !/^Alerts$/ , $syntax->languageList() ) ];
  }

  # Set up the basics. Log in if there's a user.
  my $form = Catapulse::Web::Form::Wiki->new( ctx => $c );

  my $stash = $c->stash;
  my $page = $stash->{page};
  $c->stash->{template} = 'wiki/edit.tt';

  $form->process( params => $c->request->body_parameters );
  return unless $form->validated;


  my $valid = $form->params;


  $valid->{creator} = defined $c->user ? $c->user->id : $c->pref('anonymous_id');
  $stash->{content} = $page->content;

  my $redirect = $c->stash->{path};

  # setup redirect back to edit mode.
  if ( $form->params->{submit} eq $c->localize('Save') ) {
    $redirect .= '?action=edit';
  }

  # No need to update if we have no difference between browser and db.
  if ( $c->stash->{content} && ($c->stash->{content}->body eq $form->params->{body})) {
    $c->res->redirect($redirect);
    return;
  }

  # Format content body and store the result in content.precompiled
  # This speeds up MojoMojo page rendering on /.view actions
  my $precompiled_body = $valid->{'body'};
  $precompiled_body = $c->model("DBIC::Content")->format_content( $c, $precompiled_body );

  # Make precompiled empty when we have any of: redirect, comment or include
  $valid->{'precompiled'} = $c->stash->{precompile_off} ? '' : $precompiled_body;
  $page->update_content(%$valid);

  $c->res->redirect($redirect);
  return;
}

=head1 AUTHOR

Daniel Brosseau C<dab@catapulse.org>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
