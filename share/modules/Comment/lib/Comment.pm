package Comment;

use Moose;

my $block = {
        active => 1,
        file   => 'blocks/comment.tt',
        name   => 'comment',
        parent_id
            => 0,
        position
            => undef
        };

sub install {
    my ($self, $module, $mi) = @_;

    my $schema = $mi->ctx->model->schema;

    # Add Comment block to template Main
    $mi->log("  - add Comment block to Main template");
    my $main_template = $schema->resultset('Template')->search( { name => 'Main' } )->first;
    $main_template->add_to_blocks( $block )
        or die "Cannot add Comment block to Main Template";
}

sub uninstall {
    my ($self, $module, $mi) = @_;

    my $schema = $mi->ctx->model->schema;
    $mi->log("  - delete Comment block");
    $schema->resultset('Block')->search({ name => $block->{name} })->delete_all
        or die "Cannot delete Comment block";
}

1;
