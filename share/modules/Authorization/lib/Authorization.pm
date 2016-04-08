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


my $newpages = [
    {
        path       => '/page/permission',
        template   => 'Simple',
        title      => 'Help',
        type       => 'from_controller',
        ops_to_access => [ 'permission_Page']
    },
];

sub install {
    my ($self, $module) = @_;

    # Add Operations (  edit_Page )
    foreach my $op ( @$new_operations ) {
        $self->foc_operation($op);
    }

    my $typeobj = $self->foc_typeobj( $new_typeobj );

    # Add Wiki Page
    foreach my $p ( @$newpages ) {
        $self->foc_page($p);
    }
}

sub uninstall {
    my ($self, $module, $mi) = @_;

    foreach my $op ( @$new_operations ) {
        $self->foc_typeobj( $op );
    }
}

1;
