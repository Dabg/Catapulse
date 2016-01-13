package Page;

use Moose;

my $typeobj = {
           active => 1,
           name   => 'Page'
         };

my $pagetype = {
           active => 1,
           name   => 'from_controller',
           path   => '',
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

    my $schema = $mi->ctx->model->schema;


    $schema->resultset('Typeobj')->find_or_create($typeobj);

    $mi->log("    - add $pagetype->{name} Pagetype");
    $schema->resultset('Pagetype')->find_or_create($pagetype);

    # Add Comment block to template Main
    $mi->log("    - add Content block to Main template");
    my $main_template = $schema->resultset('Template')->search( { name => 'Main' } )->first;
    $main_template->add_to_blocks( $block );

    # Add Operation ( add_Comment, view_Comment, delete_Comment)
    foreach my $op ( @$new_operations ) {
        $mi->log("    - add $op->{name} Operation");
        $schema->resultset('Operation')->find_or_create($op);
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
