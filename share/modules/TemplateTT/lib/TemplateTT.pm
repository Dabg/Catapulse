package TemplateTT;

use Moose;

my $templates = [
    {
        active => 1,
        file   => 'templates/main.tt',
        id     => 1,
        name   => 'Main',
        parent_id
            => 0,
        position
            => undef,
        wrapper
            => 'html',
    },
];


sub install {
    my ($self, $module, $mi) = @_;

    my $schema = $mi->ctx->model->schema;
    my @blocks = $schema->resultset('Block')->search->all;
    my $block_names =  [ map { $_->name } @blocks ];

    # Add Templates
    foreach my $template ( @$templates ) {
        $mi->log("    - add $template Template");
        my $b = $schema->resultset('Template')->find_or_create($template);
    }

    # Add blocks to template Main
    my $main_template = $schema->resultset('Template')->search( { name => 'Main' } )->first;
    foreach my $block_name ( @$block_names ) {
        $mi->log("    - add $block_name to Main template");
        $main_template->add_to_blocks( { name => $block_name });
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
