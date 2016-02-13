package Catapulse::Schema::Utils;

use Moose::Role;
use DateTime;

has mi   =>  (is => 'rw',
               isa => 'CatalystX::InjectModule::MI',
              required => 1,
          );


# find_or_create user
sub foc_user {
    my $self  = shift;
    my $user  = shift;
    my $roles = shift;

    $self->mi->log("find or create user " . $user->{username});
    $user->{created} = DateTime->now;
    my $schema = $self->mi->ctx->model->schema;

    my $u = $schema->resultset('User')->find_or_create($user);
    foreach my $r (@$roles) {
        $self->mi->log("add $r role to user " . $user->{username});
        $u->add_to_roles( { name => $r } );
    }
    return $u
}

sub del_user {
    my $self  = shift;
    my $user  = shift;

    $self->mi->log("delete user " . $user->{username});
    my $schema = $self->mi->ctx->model->schema;
    $schema->resultset('User')->search( { username => $user->{username} } )->delete_all;
}

sub foc_pagetype {
    my $self      = shift;
    my $pagetype  = shift;

    $self->mi->log("find or create pagetype " . $pagetype->{name});
    my $schema = $self->mi->ctx->model->schema;
    $schema->resultset('Pagetype')->find_or_create($pagetype);
}

sub del_pagetype {
    my $self      = shift;
    my $pagetype  = shift;

    $self->mi->log("del pagetype " . $pagetype->{name});
    my $schema = $self->mi->ctx->model->schema;
    $schema->resultset('Pagetype')->search( { name => $pagetype->{name} } )->delete_all;
}

sub foc_operation {
    my $self      = shift;
    my $operation  = shift;

    $self->mi->log("find or create operation " . $operation->{name});
    my $schema = $self->mi->ctx->model->schema;
    $schema->resultset('Operation')->find_or_create($operation);
}

sub del_operation {
    my $self      = shift;
    my $operation  = shift;

    $self->mi->log("del operation " . $operation->{name});
    my $schema = $self->mi->ctx->model->schema;
    $schema->resultset('Operation')->search( { name => $operation->{name} } )->delete_all;
}

# find_or_create page
sub foc_page {
    my $self  = shift;
    my $page  = shift;

    $self->mi->log("find or create page " . $page->{title});
    $page->{created} = DateTime->now;
    my $schema = $self->mi->ctx->model->schema;

    my $p = $schema->resultset('Page')->find_or_create($page);
    return $p
}

sub del_page {
    my $self  = shift;
    my $page  = shift;

    $self->mi->log("delete page " . $page->title);
    my $schema = $self->mi->ctx->model->schema;
    $schema->resultset('Page')->find( $page->id )->delete;
}

# find_or_create template
sub foc_template {
    my $self  = shift;
    my $template  = shift;

    $self->mi->log("find or create template " . $template->{name});
    my $schema = $self->mi->ctx->model->schema;

    my $p = $schema->resultset('Template')->find_or_create($template);
    return $p
}

sub del_template {
    my $self  = shift;
    my $template  = shift;

    $self->mi->log("delete template " . $template->title);
    my $schema = $self->mi->ctx->model->schema;
    $schema->resultset('Template')->find( $template->id )->delete;
}



no Moose::Role;

1;
