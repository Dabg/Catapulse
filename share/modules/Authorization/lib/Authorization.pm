package Authorization;

use Moose;
with 'Catapulse::Schema::Utils';


my $new_operations = [
    {
        active => 1,
        name   => 'permission_Page',
    },
];

my $new_typeobj =
    {
        active => 1,
        name   => 'Page',
    };


sub install {
    my ($self, $module) = @_;

    # Add Operations (  edit_Page )
    foreach my $op ( @$new_operations ) {
        $self->foc_operation($op);
    }

    my $typeobj = $self->foc_typeobj( $new_typeobj );

}

sub uninstall {
    my ($self, $module, $mi) = @_;

    foreach my $op ( @$new_operations ) {
        $self->foc_typeobj( $op );
    }
}

1;
