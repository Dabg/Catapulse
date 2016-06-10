package Wiki;

=head1 NAME

Wiki - Wiki module

=cut

use Moose;
with 'Catapulse::Schema::Utils';

my $pagetype = {
           name   => 'wiki',
           path   => '/wiki',
           active => 1,
       };


my $new_operations = [
    {
        active => 1,
        name   => 'edit_Page'
    },
];


my $wiki_pages = [
    {
        path       => '/',
        template   => 'Main',
        title      => 'index',
        type       => 'wiki',
        ops_to_access => [ 'view_Page'],
        _force     => 1,
    },
    {
        path       => '/default',
        template   => 'Main',
        title      => 'Default',
        type       => 'from_controller',
        ops_to_access => []
    },
    {
        path       => '/admin',
        template   => 'Main',
        title      => 'Administration',
        type       => 'wiki',
        ops_to_access => [ 'view_Page']
    },
    {
        path       => '/Help',
        template   => 'Main',
        title      => 'Help',
        type       => 'wiki',
        ops_to_access => [ 'edit_Page']
    },
    {
        path       => '/wiki',
        template   => 'Simple',
        title      => 'Help',
        type       => 'from_controller',
        ops_to_access => [ 'edit_Page']
    },
];

my $permissions = [
    # role, op, Page, path/*
    { role    => 'admin',
      op      => [ 'view_Page', 'edit_Page', 'add_Page', 'delete_Page', 'permission_Page' ],
      typeobj => 'Page',
      obj     => '/*',
      value   => 1,
    },
    { role    => [ 'anonymous' ],
      op      => [ 'view_Page' ],
      typeobj => 'Page',
      obj     => '/*',
      value   => 1,
    },
    { role    => 'anonymous',
      op      => [ 'view_Page' ],
      typeobj => 'Page',
      obj     => '/admin/*',
      value   => 0,
    },
];

=head2 install

module installer

=cut

sub install {
    my ($self, $module, $mi) = @_;

    my $schema = $mi->ctx->model->schema;

    # Add Pagetype 'wiki'
    $self->foc_pagetype($pagetype);

    # Add Operations (  edit_Page )
    foreach my $op ( @$new_operations ) {
        $self->foc_operation($op);
    }

    # Add Wiki Page
    foreach my $p ( @$wiki_pages ) {
        $self->foc_page($p);
    }

    foreach my $p ( @$permissions ) {
        my $rs = $self->foc_permission($p);
    }
}

=head2 uninstall

module uninstaller

=cut
sub uninstall {
    my ($self, $module, $mi) = @_;

    my $schema = $mi->ctx->model->schema;

    $schema->resultset('Pagetype')->search({ name => $pagetype->{name} })->delete_all;

    foreach my $op ( @$new_operations ) {
        $schema->resultset('Operation')->search({ name => $op->{name}})->delete_all;
    }
}

=head1 SEE ALSO

L<Catapulse>

=head1 AUTHOR

Daniel Brosseau, 2016, <dab@catapulse.org>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
