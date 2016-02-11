package Catapulse::Schema::Utils;


use Exporter;

# base class of this(Arithmetic) module
@ISA = qw(Exporter);

# Exporting the multiply and divide  routine on demand basis.
@EXPORT_OK = qw(add_user del_user);


sub add_user {
    my $schema = shift;
    my $user   = shift;
    my $roles  = shift;

    my $u = $schema->resultset('User')->find_or_create($user);
    foreach my $r (@$roles) {
        $u->add_to_roles( { name => $r } );
    }
}

sub del_user {
    my $schema = shift;
    my $user   = shift;
    my $roles  = shift;

    $schema->resultset('User')->search( { username => $user->{username} } )->delete_all;

    foreach my $r (@$roles) {
        $schema->resultset('Role')->search( { name => $r } )->delete_all;
    }
}



1;
