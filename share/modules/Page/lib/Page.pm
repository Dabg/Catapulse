package Page;

=head1 NAME

Page - Page module

=cut


use Moose;
with 'Catapulse::Schema::Utils';

my $typeobj = {
           active => 1,
           name   => 'Page'
         };

my $pagetype = {
           active => 1,
           name   => 'from_controller',
           path   => '',
       };

my $pages = [
    {
        path       => '/page/add',
        template   => 'Main',
        title      => 'add page',
        type       => 'from_controller',
        ops_to_access => [ 'add_Page'],
    },
    {
        path       => '/page/del',
        template   => 'Main',
        title      => 'delete page',
        type       => 'from_controller',
        ops_to_access => [ 'delete_Page'],
    },
    {
        path       => '/page/edit',
        template   => 'Main',
        title      => 'edit page',
        type       => 'from_controller',
        ops_to_access => [ 'edit_Page'],
    },
    {
        path       => '/page/list',
        template   => 'Main',
        title      => 'list pages',
        type       => 'from_controller',
        ops_to_access => [ 'edit_Page'],
    },
    {
        path       => '/page/jsrpc/set_permissions',
        template   => 'Main',
        title      => 'set page permissions',
        type       => 'from_controller',
        ops_to_access => [ 'permission_Page'],
    },
    {
        path       => '/page/jsrpc/clear_permissions',
        template   => 'Main',
        title      => 'clear page permissions',
        type       => 'from_controller',
        ops_to_access => [ 'permission_Page'],
    },
];

my $new_operations = [
    {
        active => 1,
        name   => 'view_Page'
    },
    {
        active => 1,
        name   => 'add_Page'
    },
    {
        active => 1,
        name   => 'delete_Page'
    },
];

=head2 install

module installer

=cut

sub install {
    my ($self, $module, $mi) = @_;

    $self->foc_typeobj($typeobj);
    $self->foc_pagetype($pagetype);

    # Add Operation ( add_Comment, view_Comment, delete_Comment)
    foreach my $op ( @$new_operations ) {
        $self->foc_operation($op);
    }

    # Add page comment
    foreach my $p ( @$pages ) {
        my $rs = $self->foc_page($p);
    }
}

=head2 uninstall

module uninstaller

=cut

sub uninstall {
    my ($self, $module, $mi) = @_;

    my $schema = $mi->ctx->model->schema;

    $schema->resultset('Typeobj')->search({ name => $typeobj->{name} })->delete_all;
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
