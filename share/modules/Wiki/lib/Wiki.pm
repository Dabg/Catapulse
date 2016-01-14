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
           title   => 'index',
           type    => 2,
           version => 1
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

sub install {
    my ($self, $module, $mi) = @_;

    my $schema = $mi->ctx->model->schema;

    # Add Comment block to template Main
    $mi->log("    - add $pagetype->{name} Pagetype");
    $schema->resultset('Pagetype')->find_or_create($pagetype);


    # Add Operation ( add_Comment, view_Comment, delete_Comment)
    foreach my $op ( @$new_operations ) {
        $mi->log("    - add $op->{name} Operation");
        $schema->resultset('Operation')->find_or_create($op);
    }

    # Add Wiki Page ( add_Comment, view_Comment, delete_Comment)
    foreach my $p ( @$wiki_pages ) {
        $mi->log("    - add $p->{title} Page");
        $schema->resultset('Page')->find_or_create($p);
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
