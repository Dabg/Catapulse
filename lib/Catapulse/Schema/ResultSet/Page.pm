package Catapulse::Schema::ResultSet::Page;


use Moose;
use namespace::autoclean;
use MooseX::NonMoose;
extends 'Catapulse::Schema::ResultSet';

=head1 NAME

Catapulse::Schema::ResultSet::Page - resultset methods on pages

=head1 METHODS

=head2 build_pages_from_path

=cut

sub build_pages_from_path {
#  my ( $self, $path, $type ) = @_;
  my ( $self, $page ) = @_;

  my $path = $page->{path};
  my $type = $page->{type};
  my $nodes = $self->retrieve_pages_from_path($path);

  my $pages = [];
  my $page_id = 0; # page /
  my ( $name, $title, $template, $version, $created, $active );
  #  foreach my $node ( @$nodes ) {
  my $nbnodes = scalar @$nodes -1;

  for ( my $n = 0; $n <= $nbnodes; $n++) {
      my $node = $nodes->[$n];
    # Build page
    if ( ! ref($node) ){
        $name     = $node;
        $title    = $node;
        $template = 1;
        $active   = 1;
        $version  = 1;
        $created  = DateTime->now;

        if ( $n == $nbnodes  ) {
            $title    = $page->{title} if defined $page->{title};
            $template = $page->{template} if defined $page->{template};
        }

        my $page = $self->find_or_create({
                                type      => $type, # 1 => from_controller, 2: wiki
                                name      => $name,
                                title     => $title,
                                template  => $template,
                                active    => $active,
                                parent_id => $page_id,
                                created   => $created,
                                version   => $version,
                            },
                           );
        $page_id = $page->id;
        push(@$pages, $page);
    }
    else {
      $page_id = $node->id;
      push(@$pages, $node);
    }
  }
  return $pages;
}


=head2 retrieve_pages_from_path

=cut

sub retrieve_pages_from_path {
  my ( $self, $path, $get_all_pages ) = @_;

  my $nodes = [ split m%/%, $path ];
  $$nodes[0] = '/';

  my $lasted_obj;
  my (@not_found, @all_pages);
  my $parent_id = 0; # page /
  foreach my $node ( @$nodes ) {
    my $page = $self->find({
                            name      => $node,
                            parent_id => $parent_id,
                           },
                          );

    $parent_id = $page->id if $page;
    if ( $page ) {
      push(@all_pages, $page);
      $lasted_obj=$page;
    }
    else {
      push(@not_found, $node);
    }
  }

  my $pages;
  if ( $get_all_pages ) {
    $pages = [ @all_pages, @not_found ];
  }
  else {
    $pages = [ $lasted_obj, @not_found ];
  }
  return $pages;
}


=head1 AUTHOR

Daniel Brosseau <dab@catapulse.org>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
