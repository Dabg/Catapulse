use utf8;
package Catapulse::Web::Controller::Page::Jsrpc;

use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }


=head1 NAME

Catapulse::Controller::Page::Jsrpc - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=cut

=head1 METHODS

=cut

=head2 set_permissions ( page/jsrpc/set_permissions )

Sets page permissions.

=cut

sub set_permissions : Local {
    my ($self, $c) = @_;

    my $args = $c->req->params;
    my ($role_id, $typeobj_id, $page_id) =
      map {delete $args->{$_}} ('role_id','typeobj_id','page_id');


    my $inheritable;
    foreach my $k ( keys %$args) {
      $inheritable->{$k} = delete $args->{$k}
        if ( $k =~ /^inheritable/);
    }

    my $perm_model = $c->model('DBIC::Permission');

    # Delete all permissions of object for this role
    $perm_model->search( {
                          role_id    => $role_id,
                          typeobj_id => $typeobj_id,
                          obj_id     => $page_id,
                         } )->delete;


    my $op_model = $c->model('DBIC::Operation');

    # Create the required permissions
    foreach my $op ( keys %$args ) {
      # Next if operation is undefined ( ! 0|1)
      if ( $args->{$op} ne '' ) {

        my $op_rs = $op_model->search({ name => $op })->single;
        die "'$op' does not exist !" if ! $op_rs;

        my $perm = $perm_model->create({
                        role_id           => $role_id,
                        typeobj_id        => $typeobj_id,
                        obj_id            => $page_id,
                        operation_id      => $op_rs->id,
                        inheritable => $inheritable->{'inheritable_' . $op },
                        value             => $args->{$op},
                                       });

      }
    }

    # clear cache
    # if ( $c->pref('cache_permission_data') ) {
    #     $c->cache->remove( 'page_permission_data' );
    # }

    $c->res->body("OK");
    $c->res->status(200);
}

=head2 clear_permissions ( page/jsrpc/clear_permissions )

Clears this page permissions for a given role (making permissions inherited).

=cut

sub clear_permissions : Local {
    my ($self, $c) = @_;


    my $args = $c->req->params;
    my ($role_id, $typeobj_id, $page_id) =
      map {delete $args->{$_}} ('role_id','typeobj_id','page_id');

    my $perm_model = $c->model('DBIC::Permission');

    # Delete all permissions of object for this role
    $perm_model->search( {
                          role_id    => $role_id,
                          typeobj_id => $typeobj_id,
                          obj_id     => $page_id,
                         } )->delete;

    # clear cache
    # if ( $c->pref('cache_permission_data') ) {
    #   $c->cache->remove( 'page_permission_data' );
    # }

    $c->res->body("OK");
    $c->res->status(200);

}

=head1 AUTHOR

Daniel Brosseau <dab@catapulse.org>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
