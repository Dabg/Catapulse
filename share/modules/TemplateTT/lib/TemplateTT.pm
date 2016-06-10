package TemplateTT;

=head1 NAME

TemplateTT - TemplateTT module

=cut

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


=head2 install

module installer

=cut
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

=head2 uninstall

module uninstaller

=cut
sub uninstall {
    my ($self, $module, $mi) = @_;

    my $schema = $mi->ctx->model->schema;
    $mi->log("    - delete templates");

    # Delete templates
    foreach my $template ( @$templates ) {
        my $b = $schema->resultset('Template')->search({ name => $template->{name} })->delete_all;
    }
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
