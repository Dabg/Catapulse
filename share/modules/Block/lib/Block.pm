package Block;

use Moose;

my $blocks = [
    {
        active => 1,
        file   => 'blocks/querylog.tt',
        id     => 10,
        name   => 'querylog',
        parent_id
            => 0,
        position
            => undef
        },
    {
        active => 1,
        file   => 'blocks/navbar.tt',
        id     => 1,
        name   => 'navbar',
        parent_id
            => 0,
        position
            => undef
        },
    {
        active => 1,
        file   => 'blocks/breadcrumbs.tt',
        id     => 2,
        name   => 'breadcrumbs',
        parent_id
            => 0,
        position
            => undef
        },
    {
        active => 1,
        file   => 'blocks/messages.tt',
        id     => 3,
        name   => 'message',
        parent_id
            => 0,
        position
            => undef
        },
    {
        active => 1,
        file   => 'blocks/sidebar.tt',
        id     => 6,
        name   => 'sidebar',
        parent_id
            => 0,
        position
            => undef
        },
    {
        active => 1,
        file   => 'blocks/footer.tt',
        id     => 7,
        name   => 'footer',
        parent_id
            => 0,
        position
            => undef
        },
    {
        active => 1,
        file   => 'blocks/links.tt',
        id     => 8,
        name   => 'links',
        parent_id
            => 0,
        position
            => undef
        },
];

sub install {
    my ($self, $module, $mi) = @_;

    my $schema = $mi->ctx->model->schema;

    $mi->log("  - populate blocks");
    # Add Blocks
    foreach my $block ( @$blocks ) {
        my $b = $schema->resultset('Block')->find_or_create($block);
    }
}

sub uninstall {
    my ($self, $module, $mi) = @_;

    my $schema = $mi->ctx->model->schema;
    $mi->log("  - delete blocks");

    # Delete blocks
    foreach my $block ( @$blocks ) {
        my $b = $schema->resultset('Block')->search({ name => $block->{name} })->delete_all;
    }
}

1;
