package Wiki;

use Moose;
with 'Catapulse::Schema::Utils';

my $pagetype = {
           name   => 'wiki',
           path   => '/wiki',
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
    my $pages = {};
    foreach my $p ( @$wiki_pages ) {
        my $rs = $self->foc_page($p);
        $pages->{$rs->title} = $rs;
    }

    foreach my $p ( @$permissions ) {
        my $rs = $self->foc_permission($p);
    }

    # # # Add permissions
    # my $typepage = $schema->resultset('Typeobj')->search({ name => 'Page'})->first;
    # my $op_view_page = $schema->resultset('Operation')->search({ name => 'view_Page'})->first;
    # my $op_perm_page = $schema->resultset('Operation')->search({ name => 'permission_Page'})->first;

    # my $role_admin     = $schema->resultset('Role')->search({ name => 'admin'})->first;
    # my $role_anonymous = $schema->resultset('Role')->search({ name => 'anonymous'})->first;

    # # Admin and anonymous can view page / (index)
    # my $perms =[
    #     # Admin can 'view' on page / (recursively)
    #     { role_id => $role_admin->id,
    #       typeobj_id => $typepage->id,
    #       obj_id => $pages->{index}->id,
    #       operation_id => $op_view_page->id,
    #       value => 1,
    #       inheritable => 1
    #   },
    #     # Admin can permission on page / (recursively)
    #     { role_id => $role_admin->id,
    #       typeobj_id => $typepage->id,
    #       obj_id => $pages->{index}->id,
    #       operation_id => $op_perm_page->id,
    #       value => 1,
    #       inheritable => 1
    #   },
    #     # Anonymous can 'view' on page / (recursively)
    #     { role_id => $role_anonymous->id,
    #       typeobj_id => $typepage->id,
    #       obj_id => $pages->{index}->id,
    #       operation_id => $op_view_page->id,
    #       value => 1,
    #       inheritable => 1
    #   },
    #     # Anonymous can not 'view' on page /admin (recursively)
    #     { role_id => $role_anonymous->id,
    #       typeobj_id => $typepage->id,
    #       obj_id => $pages->{Administration}->id,
    #       operation_id => $op_view_page->id,
    #       value => 0,
    #       inheritable => 1
    #   },
    # ];
    # foreach my $p ( @$perms ) {
    #     $mi->log("    - add permission $p->id");
    #     $schema->resultset('Permission')->find_or_create($p);
    # }

}

sub uninstall {
    my ($self, $module, $mi) = @_;

    my $schema = $mi->ctx->model->schema;

    $schema->resultset('Pagetype')->search({ name => $pagetype->{name} })->delete_all;

    foreach my $op ( @$new_operations ) {
        $schema->resultset('Operation')->search({ name => $op->{name}})->delete_all;
    }
}

1;
