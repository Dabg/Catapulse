package Catapulse::Web::Controller::Root;

use Moose;
use namespace::autoclean;
use Catapulse::Web::PageFactory;

BEGIN { extends 'Catalyst::Controller' }

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config(namespace => '');

=encoding utf-8

=head1 NAME

Catapulse::Web::Controller::Root - Root Controller for Catapulse::Web

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 begin

run for all URLs (/)

=cut

sub auto :Private {
    my ($self, $c) = @_;

    # default css
    $c->assets->include("static/bootstrap-3.3.6/css/bootstrap.min.css");
    $c->assets->include("static/css/font-awesome.min.css");


    # # default js
    $c->assets->include("static/js/jquery-1.11.1.min.js");
    $c->assets->include("static/js/jquery-migrate-1.1.1.js");
    $c->assets->include("static/bootstrap-3.3.6/js/bootstrap.min.js");
    $c->assets->include("static/js/app.js");

    # # # used by toogle/edit/delete in lists
    $c->assets->include("static/js/jquery.livequery.js");
    $c->assets->include("static/js/jquery.pa.list_actions.js");

    # comments
    $c->assets->include("/static/css/jquery-comments.css");
    $c->assets->include("/static/js/jquery-comments.min.js");

}

=head2 index

The root page (/)

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    # Hello World
    $c->response->body( $c->loc('welcome_message') );
}

=head2 default

Standard 404 error page

=cut

sub default :Path {
    my ( $self, $c ) = @_;

}

=head2 access_denied

access_denied page

=cut

sub access_denied :Path('access_denied') {
    my ( $self, $c ) = @_;
    $c->response->status(401);
}

=head2 not_found

Page not_found

=cut

sub not_found :Path('not_found') {
    my ( $self, $c ) = @_;
    $c->response->status(404);
}

=head2 end

Attempt to render a view, if needed.

Calculate content of controller, blocks and build page

=cut

sub end : ActionClass('RenderView') {
  my ( $self, $c) = @_;

  return 1 if $c->req->method eq 'HEAD';
  return  if $c->response->status =~ /^(?:204|3\d\d)$/;
  return $c->res->output if ( $c->res->output && ! $c->stash->{template} );

  my $zoom_in = $c->req->param('zoom_in');

  # If page exist in db
  if ( my $page = $c->stash->{page} ) {

    # Build 'content' If page is a controller
    # Render controller with TTBlock
    if ( ! $c->stash->{template} && $c->action ne 'default' && ! $c->res->body) {
      $c->stash->{template} = $c->action . '.tt';
    }

    if ( $c->stash->{template} ) {
      $c->stash->{content} = $c->view('TTBlock')->render($c, $c->stash->{template}) or die "Error: $!";
    }

    my $template;
    if ( $c->stash->{page_action}) {
        $template = $c->stash->{page_action}->template;
    }
    elsif ( $page->template->active ){
        $template = $page->template
    }

    $c->stash->{template} = $template->file;
    # process Blocks
    my $pagefactory = Catapulse::Web::PageFactory->new( ctx => $c, template => $template);
    $pagefactory->process;


    $c->forward( $c->view('TTPage') );
  }
  # KO page is not in stash
  # Forward to TT View
  else {
    $c->forward( $c->view ) if ! $c->res->body;

    # If we are in debug mode alert appears
    my $body   = $c->res->body;
    my $action = $c->action;
    if ( $action ne 'default') {
        my $path = "/$action";
        $path =~ s|^/index$|/|;
        $path =~ s|/index$||;

        my $url_do_add = $c->uri_for("/page/add",{
                               type    => '2', # 2 => wiki
                               name    => 'XXX',
                               path    => $path,
                               title   => $path,
                               template => 1,
                             });


      my $alert = "<h3>This page is not saved !</h3> use this link to save the page : <a href=\"$url_do_add\">Add page</a><hr />";
      $body =~ s/^/$alert/;
      $c->res->body($body);
    }
  }
}


=head1 AUTHOR

dab,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
