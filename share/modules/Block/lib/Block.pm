package Block;

use Moose;
with 'Catapulse::Schema::Utils';

my $blocks = [
    {
        active => 1,
        file   => 'blocks/querylog.tt',
        name   => 'querylog',
        },
    {
        active => 1,
        file   => 'blocks/navbar.tt',
        name   => 'navbar',
        },
    {
        active => 1,
        file   => 'blocks/breadcrumbs.tt',
        name   => 'breadcrumbs',
        },
    {
        active => 1,
        file   => 'blocks/messages.tt',
        name   => 'message',
        },
    {
        active => 1,
        file   => 'blocks/sidebar.tt',
        name   => 'sidebar',
        },
    {
        active => 1,
        file   => 'blocks/footer.tt',
        name   => 'footer',
        },
    {
        active => 1,
        file   => 'blocks/links.tt',
        name   => 'links',
        },
    {
        active => 1,
        file   => 'blocks/content.tt',
        name   => 'content',
        },
];

my $pagetype = {
           name   => 'from_controller',
           path   => '',
           active => 1,
       };


sub install {
    my ($self, $module, $mi) = @_;

    # Add Pagetype 'from_controller'
    $self->foc_pagetype($pagetype);

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
