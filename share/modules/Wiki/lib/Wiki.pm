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
