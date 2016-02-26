package Comment;

use Moose;
with 'Catapulse::Schema::Utils';

my $pages = [
    {
        path       => '/comment/del',
        template   => 'Main',
        title      => 'delete comment',
        type       => 'from_controller',
        ops_to_access => [ 'delete_Comment'],
    },
];


my $typeobj = {
           active => 1,
           name   => 'Comment'
         };

my $block = {
        active    => 1,
        file      => 'blocks/comment.tt',
        name      => 'comment',
        parent_id => 0,
        };

my $operations = [
    {
        active => 1,
        name   => 'view_Comment'
    },
    {
        active => 1,
        name   => 'add_Comment'
    },
    {
        active => 1,
        name   => 'delete_Comment'
    },
];

my $permissions = [
    # role, op, Page, path/*
    { role    => 'admin',
      op      => [ 'view_Comment', 'add_Comment', 'delete_Comment' ],
      typeobj => 'Page',
      obj     => '/*',
      value   => 1,
    },
    { role    => 'anonymous',
      op      => [ 'view_Comment' ],
      typeobj => 'Page',
      obj     => '/*',
      value   => 1,
    },
    { role    => 'anonymous',
      op      => [ 'delete_Comment' ],
      typeobj => 'Page',
      obj     => '/comment/del',
      value   => 0,
    },
];

sub install {
    my ($self, $module, $mi) = @_;

    my $schema = $mi->ctx->model->schema;

    # Add page comment
    foreach my $p ( @$pages ) {
        my $rs = $self->foc_page($p);
    }

    $schema->resultset('Typeobj')->find_or_create($typeobj)
        or die "Cannot create Comment tyeobj";

    # Add Comment block to template Main
    $mi->log("    - add Comment block to Main template");
    my $main_template = $schema->resultset('Template')->search( { name => 'Main' } )->first;
    $main_template->add_to_blocks( $block );

    # Add Operation ( add_Comment, view_Comment, delete_Comment)
    foreach my $op ( @$operations ) {
        $mi->log("    - add $op->{name} Operation");
        $schema->resultset('Operation')->find_or_create($op);
    }

    # Add some Permissions
    foreach my $p ( @$permissions ) {
        my $rs = $self->foc_permission($p);
    }
}

sub uninstall {
    my ($self, $module, $mi) = @_;

    my $schema = $mi->ctx->model->schema;
    $mi->log("  - delete Comment block");
    $schema->resultset('Typeobj')->search({ name => $typeobj->{name} })->delete_all;

    $schema->resultset('Block')->search({ name => $block->{name} })->delete_all;
}

1;
