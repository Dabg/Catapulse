package Block;

use Moose;
with 'Catapulse::Schema::Utils';

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

    # Add Blocks
    foreach my $block ( @$blocks ) {
        $self->foc_block($block);
    }
}

sub uninstall {
    my ($self, $module, $mi) = @_;

    # Delete blocks
    foreach my $block ( @$blocks ) {
        die "not implemented";
    }
}

1;
