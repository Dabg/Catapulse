use utf8;
package Catalyst::Plugin::Page;

use Moose::Role;
use namespace::autoclean;

use Algorithm::IncludeExclude;
use URI::Escape;
use Params::Validate qw(:all);

use vars qw($VERSION);
$VERSION = '0.01';

my $populated_path = '/page/.populated';

=head2 cache_ie_list

include/exclude list accessor

=cut

my $ie;
sub cache_ie_list { # XXX?
    return $ie;
}


after 'setup_finalize' => sub {
    my $c = shift;

    # Paths protected
    $ie = Algorithm::IncludeExclude->new;
    $ie->include();
    $ie->exclude('static');

    $c->_populate_controllers_pages
    #if ! $c->model('DBIC::Page')->search( { name => });

};


around 'dispatch' => sub {
  my $orig = shift;
  my $c    = shift;

  # Return if excluded
  my @path = split m{/}, uri_unescape($c->req->uri->path);
  shift @path;
  my $include = $c->cache_ie_list->evaluate(@path);

  # Return if path is exclude from $ie
  return $c->$orig(@_) unless $include;

  # Return cache of page if exist
  # TODO : Cache page

  my $path = $c->req->uri->path;
  my $internalpath;
  # The path contains an action ?
  if ( $path =~ /^.*\+([a-z]*)$/ ){
    # Save action to use after.
    $c->stash->{action} = $1;
    # Delete the last argument (+edit, +permission, ...)
    delete ${$c->req->args}[-1];
  }

  # Search user
  my $user;
  if ( $c->user_exists() ) {
    $user = $c->user->obj;
  }

  # if no user is logged in
  if (not $user) {
    # if anonymous user is allowed
    my $anonymous = "anonymous";
    if ($anonymous) {
      # get anonymous user for no logged-in users
      $user = $c->model('DBIC::User') ->search(
                                               {username => $anonymous},
                                              )->single;
      $c->stash->{anonymous_user} = $user;
    }
  }

  # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  # Plutot que de crer un utilisateur 'anonymous'
  # utiliser simplement les roles.
  # Si user_exists alors roles = map $_->name user->roles
  # sinon roles = [ 'anonymous' ]
  # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

  # Save user roles
  $c->stash->{user_roles} = [ map { $_->name } $user->roles ];

  # path = c.action or c.req.args if default
  my $ctp_path = $c->ctp_path;
  $c->stash->{path} = $ctp_path;

  # TODO
  # Retrieve rbac permission cache with path
  # - ! rbac_cache => $c->res->redirect('/access_denied')
  # - else get permissions

  # Retrieve content page cache with path
  # - content exist => return content
  # - else get content


  # Returns all objects representing the path
  my $pages = $c->model('DBIC::Page')->retrieve_pages_from_path( $ctp_path, 1 );


  # the last node of page
  my $page = $$pages[-1];
  # Add opeartions adds we need to check
  my $additional_operations =[];

  # Test if redirection exist in config file
  if ( $c->stash->{action} && ref($page) ){
      # Get the 'redirection' on the config file.
      $internalpath = $c->config->{'Plugin::Page'}->{typepage}->{$page->type->name}->{$c->stash->{action}};

      if ( ! $internalpath ) {
          $c->stash->{page} = $page;
          $c->redispatch('/access_denied', $ctp_path);
          return $c->$orig(@_);
      }
      push(@$additional_operations, $c->stash->{action} . '_Page');
  }

  # Can not access to page
  if ( ( ref($page) && ! $page->active )
       ||
       $c->can('rbac') && $c->rbac && ! $c->can_access($pages, $additional_operations) ){
          $c->stash->{page} = $$pages[0];
          # not necessary to really redirect
          # It's a equivalent to forward (?)
           $c->redispatch('/access_denied', $ctp_path);
           return $c->$orig(@_)
        }
  # Can access to page
  else {
    # Page exist in db
    if ( ref ($page) ) {
      $c->stash->{page} = $page;
      # if an action is required on the page (+edit/+permission/...)
      if ( $c->stash->{action} ) {
          $c->stash->{page_action} = $c->model('DBIC::Page')->retrieve_pages_from_path( $internalpath );
          $c->redispatch($internalpath, $ctp_path);
      }
      elsif ( $page->type->name eq 'from_controller' ) {
          # Nothing ... continue
      }
      else {
          my $internalpath = $page->type->path;
          $c->redispatch($internalpath, $ctp_path);
      }
    }
    # Page doesnot exist on db
      else {
      $c->new_page($user, $ctp_path, $pages);
    }
  }
  return $c->$orig(@_);
};


# From http://wiki.catalystframework.org/wiki/wikicookbook/safedispatchusingpath.view
sub redispatch{
  my ($c, $internalpath, $ctp_path) = @_;

  $c->request->path($internalpath);
  $c->dispatcher->prepare_action($c);
  $c->request->path($ctp_path);
}



# path = c.action or c.req.args if default
# replace 'index' by '/'
sub ctp_path{
  my ( $c, $action ) = @_;

  $action ||= $c->action;
  my $path = $action;
  $path    = uri_unescape( join '/', @{$c->req->args} )
    if ( $action eq 'default');
  $path = "/$path";
  $path =~ s|//|/|g;
  $path =~ s/\?.*$//;
  $path =~ s|^/index$|/|;
  $path =~ s|/index$||;

  my $params = [{path => $path}];
  eval { validate(
                  @$params,
                  { path => { regex => qr/^[\/\.\w_\-]+$/ }}
                 )
       };

  $c->res->redirect('/access_denied')
    if $@;

  return $path
}

sub new_page{
  my ( $c, $user, $path, $pages ) = @_;

  if ( $c->can('rbac') && $c->rbac && ! $c->can_access($pages, ['add_Page'])){
          $c->request->path('/access_denied');
          $c->dispatcher->prepare_action($c);

          $c->stash->{page} = $$pages[0];
      }
  # action eq 'default' ?
  if ( $c->action eq 'default') {
      $c->stash->{template} = "page/not_found.tt";
      my $url_do_add = $c->uri_for("/page/add",{
                               type    => '2', # 2 => wiki
                               name    => $$pages[-1],
                               path    => $path,
                               title   => $path,
                               template => 1,
                             });

      $c->stash->{url_do_add} = $url_do_add;
      $c->stash->{path}       = $path;

      my $p = $c->model('DBIC::Page')->retrieve_pages_from_path( '/page/not_found' );
      $c->stash->{page} = $p;
  }
}

sub redirect_to_action {
    my ($c, $controller, $action, @params) =@_;

    $c->res->redirect($c->uri_for($c->controller($controller)->action_for($action), @params));
    $c->detach;
}

sub _populate_controllers_pages {
    my ($c, $force ) = @_;

    my $node = $c->model('DBIC::Page')->retrieve_pages_from_path($populated_path);
    if ( ! $force && ref ($node) ) {
        $c->mi->log("Page already populated");
        return;
    }

    foreach my $path ( $c->_get_all_paths ){
        $c->model('DBIC::Page')->build_pages_from_path({ path => $path, type => 1});
    }

    $c->model('DBIC::Page')->build_pages_from_path( { path => $populated_path, type => 1 });
}

sub _get_all_paths {
    my $c = shift;

    my @paths;
    # Save info about dispatch_types
    my $dispatcher = $c->dispatcher;
    foreach my $c_name ($c->controllers(qr//)) {
        my $controller = $c->controller($c_name);
        my @actions = $dispatcher->get_containers($controller->action_namespace($c));
        $c->mi->log("Looking at Controller $c_name for actions entries:");

        foreach my $ac ($actions[-1]) {
            my $acts = $ac->actions;
            foreach my $key (keys(%$acts)) {
                my $action = $acts->{$key};

                next if ( $action->name =~/_BEGIN|_AUTO|_ACTION|_DISPATCH|_END|auto|begin|end$/ );

                # find or create page row if doesnot exist
                my $path = "/$action";
                $path =~ s|^/index$|/|;
                $path =~ s|/index$||;

                my $page = { path => $path,
                             type => 1,
                         };
                $c->mi->log("  find or create page $path");
                push(@paths, $path);
            }
        }
    }
    return @paths;
}
1;

__END__

=head1 NAME

Catalyst::Plugin::Page

=head1 SYNOPSIS

  use Catalyst qw/ Page /;


=head1 DESCRIPTION

Autocreate page

it depends on the following modules :

Catapulse::Web::Admin::Page

Catapulse::Schema::Result::Page

=back

=head1 SEE ALSO

L<Catalyst>.

=head1 AUTHORS

Daniel Brosseau, 2015, <dab@catapulse.org>

=head1 LICENSE

This library is free software . You can redistribute it and/or modify
it under the same terms as perl itself.

=cut
