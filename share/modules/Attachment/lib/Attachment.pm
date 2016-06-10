package Attachment;

=head1 NAME

Attachment - Attachment module

=cut

use Moose;
with 'Catapulse::Schema::Utils';

my $pages = [
    {
        path       => '/attachment',
        template   => 'Main',
        title      => 'Upload/Download files',
        type       => 'from_controller',
        ops_to_access => [ 'add_Attachment'],
    },
];


my $operations = [
    {
        active => 1,
        name   => 'view_Attachment'
    },
    {
        active => 1,
        name   => 'add_Attachment'
    },
    {
        active => 1,
        name   => 'delete_Attachment'
    },
];

my $permissions = [
    # role, op, Page, path/*
    { role    => 'admin',
      op      => [ 'view_Attachment', 'add_Attachment', 'delete_Attachment' ],
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

    # Add Operation ( add_Comment, view_Comment, delete_Comment)
    foreach my $op ( @$operations ) {
        $self->foc_operation($op);
    }

    foreach my $p ( @$permissions ) {
        my $rs = $self->foc_permission($p);
    }
}

=head2 uninstall

module uninstaller

=cut
sub uninstall {
    my ($self, $module, $mi) = @_;

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
