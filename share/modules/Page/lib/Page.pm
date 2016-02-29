package Page;

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

my $block = {
        active => 1,
        file   => 'blocks/content.tt',
        id     => 4,
        name   => 'content',
        parent_id
            => 0,
        position
            => undef
        };

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

sub install {
    my ($self, $module, $mi) = @_;

    $self->foc_typeobj($typeobj);
    $self->foc_pagetype($pagetype);

    # Add Comment block to template Main
    $self->foc_template({name => 'Main'})->add_to_blocks( $block );

    # Add Operation ( add_Comment, view_Comment, delete_Comment)
    foreach my $op ( @$new_operations ) {
        $self->foc_operation($op);
    }

    # Add page comment
    foreach my $p ( @$pages ) {
        my $rs = $self->foc_page($p);
    }
}

sub uninstall {
    my ($self, $module, $mi) = @_;

    my $schema = $mi->ctx->model->schema;

    $schema->resultset('Typeobj')->search({ name => $typeobj->{name} })->delete_all;
    $schema->resultset('Pagetype')->search({ name => $pagetype->{name} })->delete_all;

    $schema->resultset('Block')->search({ name => $block->{name} })->delete_all;

    foreach my $op ( @$new_operations ) {
        $schema->resultset('Operation')->search({ name => $op->{name}})->delete_all;
    }
}

1;
