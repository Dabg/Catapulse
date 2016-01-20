package Wiki;

use Moose;

my $pagetype = {
           active => 1,
           name   => 'wiki',
           path   => '/wiki',
       };

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
        name   => 'edit_Page'
    },
];

my $wiki_pages = [
    {
        active     => 1,
        created    => '',
        id         => 1,
        name       => '/',
        parent_id  => 0,
        template   => 1,
        title      => 'index',
        type       => 2,
        version    => 1
         },
    {
        active     => 1,
        created    => '',
        id         => 2,
        name       => 'default',
        parent_id  => 1,
        template   => 1,
        title      => 'default',
        type       => 2,
        version    => 1
    },
    {
        active     => 1,
        created    => '',
        id         => 3,
        name       => 'admin',
        parent_id  => 1,
        template   => 1,
        title      => 'Administration',
        type       => 2,
        version    => 1
    },
    {
        active     => 1,
        created    => '',
        id         => 4,
        name       => 'Help',
        parent_id  => 1,
        template   => 1,
        title      => 'Help',
        type       => 2,
        version    => 1
    },
];

my $ops_to_access_pages = [
    {
        obj_id       => 1,
        operation_id => 6,
        typeobj_id   => 1
    },
    {
        obj_id       => 3,
        operation_id => 6,
        typeobj_id   => 1
    },
];

sub install {
    my ($self, $module, $mi) = @_;

    my $schema = $mi->ctx->model->schema;

    # Add Comment block to template Main
    $mi->log("    - add $pagetype->{name} Pagetype");
    $schema->resultset('Pagetype')->find_or_create($pagetype);


    # Add Operation (  edit_Page )
    foreach my $op ( @$new_operations ) {
        $mi->log("    - add $op->{name} Operation");
        $schema->resultset('Operation')->find_or_create($op);
    }

    # Add Wiki Page
    my $pages = {};
    foreach my $p ( @$wiki_pages ) {
        $mi->log("    - add $p->{title} Page");
        $p->{created} = DateTime->now;
        my $rs = $schema->resultset('Page')->find_or_create($p);
        $pages->{$rs->title} = $rs;
    }


    # Protect some Wiki Page
    foreach my $p ( @$ops_to_access_pages ) {
        $mi->log("    - protect Page $p->{obj_id}");
        $schema->resultset('ObjOperation')->find_or_create($p);
    }

    # Add permissions
    my $typepage = $schema->resultset('Typeobj')->search({ name => 'Page'})->first;
    my $op_view_page = $schema->resultset('Operation')->search({ name => 'view_Page'})->first;
    my $op_perm_page = $schema->resultset('Operation')->search({ name => 'permission_Page'})->first;

    my $role_admin     = $schema->resultset('Role')->search({ name => 'admin'})->first;
    my $role_anonymous = $schema->resultset('Role')->search({ name => 'anonymous'})->first;

    # Admin and anonymous can view page / (index)
    my $perms =[
        # Admin can 'view' on page / (recursively)
        { role_id => $role_admin->id,
          typeobj_id => $typepage->id,
          obj_id => $pages->{index}->id,
          operation_id => $op_view_page->id,
          value => 1,
          inheritable => 1
      },
        # Admin can permission on page / (recursively)
        { role_id => $role_admin->id,
          typeobj_id => $typepage->id,
          obj_id => $pages->{index}->id,
          operation_id => $op_perm_page->id,
          value => 1,
          inheritable => 1
      },
        # Anonymous can 'view' on page / (recursively)
        { role_id => $role_anonymous->id,
          typeobj_id => $typepage->id,
          obj_id => $pages->{index}->id,
          operation_id => $op_view_page->id,
          value => 1,
          inheritable => 1
      },
        # Anonymous can not 'view' on page /admin (recursively)
        { role_id => $role_anonymous->id,
          typeobj_id => $typepage->id,
          obj_id => $pages->{Administration}->id,
          operation_id => $op_view_page->id,
          value => 0,
          inheritable => 1
      },
    ];
    foreach my $p ( @$perms ) {
        $mi->log("    - add permission $p->id");
        $schema->resultset('Permission')->find_or_create($p);
    }
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
