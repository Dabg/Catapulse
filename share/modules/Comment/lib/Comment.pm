package Comment;

use Moose;

my $blocks = [
    {
        active => 1,
        file   => 'blocks/comment.tt',
        id     => 5,
        name   => 'comment',
        parent_id
            => 0,
        position
            => undef
        },
    {
        active => 1,
        file   => 'blocks/last_comments.tt',
        id     => 9,
        name   => 'last_comments',
        parent_id
            => 0,
        position
            => undef
        },

];

sub install {
    my ($self, $module, $mi) = @_;

    my $schema = $mi->ctx->model->schema;

    $mi->log("  - populate comment blocks");
    # Add Blocks
    foreach my $block ( @$blocks ) {
        my $b = $schema->resultset('Block')->find_or_create($block);
    }
}

sub uninstall {
    my ($self, $module, $mi) = @_;

    my $schema = $mi->ctx->model->schema;
    $mi->log("  - delete comment blocks");

    # Delete blocks
    foreach my $block ( @$blocks ) {
        my $b = $schema->resultset('Block')->search({ name => $block->{name} })->delete_all;
    }
}

1;
