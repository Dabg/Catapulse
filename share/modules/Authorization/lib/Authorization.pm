package Authorization;

use Moose;


my $new_operations = [
    {
        active => 1,
        name   => 'permission_Page',
        id => 5, # XXX : Change this !!!
    },
];

sub install {
    my ($self, $module, $mi) = @_;

    my $schema = $mi->ctx->model->schema;

    # Add Operation ( add_Comment, view_Comment, delete_Comment)
    foreach my $op ( @$new_operations ) {
        $mi->log("    - add $op->{name} Operation");
        $schema->resultset('Operation')->find_or_create($op);
    }

}

sub uninstall {
    my ($self, $module, $mi) = @_;

    my $schema = $mi->ctx->model->schema;

    foreach my $op ( @$new_operations ) {
        $schema->resultset('Operation')->search({ name => $op->{name}})->delete_all;
    }
}

1;
