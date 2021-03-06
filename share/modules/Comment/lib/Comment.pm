package Comment;

=head1 NAME

Comment - Comment module

=cut

use Moose;
with 'Catapulse::Schema::Utils';

my $pages = [
    {
        path       => '/comment',
        template   => 'Main',
        title      => 'view comment',
        type       => 'from_controller',
        ops_to_access => [ 'view_Comment'],
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
    # {
    #     active => 1,
    #     name   => 'view_Comment'
    # },
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
];

=head2 install

module installer

=cut
sub install {
    my ($self, $module, $mi) = @_;

    my $schema = $mi->ctx->model->schema;

    # Add page comment
    foreach my $p ( @$pages ) {
        my $rs = $self->foc_page($p);
    }

    $self->foc_typeobj($typeobj);

    # Add Comment block to template Main
    $mi->log("    - add Comment block to Main template");
    my $main_template = $schema->resultset('Template')->search( { name => 'Main' } )->first;
    $main_template->add_to_blocks( $block );

    # Add Operation ( add_Comment, view_Comment, delete_Comment)
    foreach my $op ( @$operations ) {
        $self->foc_operation($op);
    }

    # Add some Permissions
    foreach my $p ( @$permissions ) {
        my $rs = $self->foc_permission($p);
    }
}

=head2 uninstall

module uninstaller

=cut
sub uninstall {
    my ($self, $module, $mi) = @_;

    my $schema = $mi->ctx->model->schema;
    $mi->log("  - delete Comment block");
    $schema->resultset('Typeobj')->search({ name => $typeobj->{name} })->delete_all;

    $schema->resultset('Block')->search({ name => $block->{name} })->delete_all;
}

=head1 SEE ALSO

L<Catapulse>

=head1 AUTHOR

Daniel Brosseau, 2016, <dab@catapulse.org>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
1;
