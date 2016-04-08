package TemplateTT;

use Moose;
with 'Catapulse::Schema::Utils';

my $templates = [
    {
        active    => 1,
        file      => 'templates/main.tt',
        name      => 'Main',
        parent_id => 0,
        position  => undef,
        wrapper   => 'html',
        blocks    => [ qw /navbar breadcrumbs message sidebar footer links content querylog / ],
    },
    {
        active    => 1,
        file      => 'templates/simple.tt',
        name      => 'Simple',
        parent_id => 0,
        position  => undef,
        wrapper   => 'html',
        blocks    => [ qw /breadcrumbs message content querylog/ ],
    },
];


sub install {
    my ($self, $module, $mi) = @_;

    my $schema = $mi->ctx->model->schema;
    my @blocks = $schema->resultset('Block')->search->all;
    my $block_names =  [ map { $_->name } @blocks ];

    # Add Templates
    foreach my $template ( @$templates ) {
        $self->foc_template($template);
    }
}

sub uninstall {
    my ($self, $module, $mi) = @_;

    my $schema = $mi->ctx->model->schema;
    $mi->log("    - delete templates");

    # Delete templates
    foreach my $template ( @$templates ) {
        my $b = $schema->resultset('Template')->search({ name => $template->{name} })->delete_all;
    }
}

1;
