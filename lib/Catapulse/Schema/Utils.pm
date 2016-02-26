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

sub foc_block {
    my $self  = shift;
    my $block = shift;

    $self->is_exist('block', $block);
    $self->mi->log("find or create block " . $block->{name});
    my $schema = $self->mi->ctx->model->schema;
    $schema->resultset('Block')->find_or_create($block);
}

sub foc_pagetype {
    my $self      = shift;
    my $pagetype  = shift;

    $self->is_exist('pagetype', $pagetype);
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

sub foc_typeobj {
    my $self      = shift;
    my $typeobj  = shift;

    $self->is_exist('typeobj', $typeobj);
    $self->mi->log("find or create typeobj " . $typeobj->{name});
    my $schema = $self->mi->ctx->model->schema;
    $schema->resultset('Typeobj')->find_or_create($typeobj);
}

sub del_typeobj {
    my $self      = shift;
    my $typeobj  = shift;

    $self->mi->log("del typeobj " . $typeobj->{name});
    my $schema = $self->mi->ctx->model->schema;
    $schema->resultset('Typeobj')->search( { name => $typeobj->{name} } )->delete_all;
}

sub foc_operation {
    my $self      = shift;
    my $operation  = shift;

    $self->is_exist('operation', $operation);
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
    my $schema = $self->mi->ctx->model->schema;

    my $template = $self->foc_template( { name => $page->{template} } );

    $page->{template}  = $template->id or die "Can not find template " . $page->{template};

    my $pagetype = $schema->resultset('Pagetype')->search( { name => $page->{type} } )->first;
    $page->{type}  = $pagetype->id or die "Can not find type " . $page->{type};

    my $ops_to_access = delete $page->{ops_to_access};

    my $pages = $schema->resultset('Page')->build_pages_from_path($page);
    my $p = $$pages[-1];
    my $typeobj = $schema->resultset('Typeobj')->search( { name => 'Page' } )->first;

    foreach my $operation ( @$ops_to_access) {
        my $op = $schema->resultset('Operation')->search( { name => $operation } )->first;
        $p->add_to_ops_to_access( { name => $operation
                                });
    }

    return $p;
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

    $self->is_exist('template', $template);
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

# find_or_create permission
sub foc_permission {
    my $self = shift;
    my $perm = shift;

    #$self->mi->log("find or create page " . $page->{title});
    my $schema = $self->mi->ctx->model->schema;

    my $typeobj = $schema->resultset('Typeobj')->search({ name => $perm->{typeobj}})->first
        or die "can not find " .$perm->{typeobj} . " typeobj !";

    my @roles;
    ref($perm->{role}) eq 'ARRAY' ?
        push( @roles, @{ $perm->{role} } ) :
        push( @roles, $perm->{role} );

    my @operations;
    ref($perm->{op}) eq 'ARRAY' ?
        push( @operations, @{ $perm->{op} } ) :
        push( @operations, $perm->{op} );

    foreach my $role ( @roles ) {
        my $r = $schema->resultset('Role')->search({ name => $role})->first
            or die "can not find $role role !";

        foreach my $operation ( @operations ) {
            my $op = $schema->resultset('Operation')->search({ name => $operation})->first
                or die "can not find $operation operation !";

            # search obj
            if ( $typeobj->name eq 'Page' ) {
                my $path = $perm->{obj};
                my $inheritable = 0;
                $inheritable = 1 if ( $path =~ s/\*$// );
                $self->mi->log("find or create permission : $role -> $operation -> $path -> " . $perm->{value});

                my $obj = $schema->resultset('Page')->retrieve_pages_from_path($path)
                    or die "can not find $path Page !";

                $schema->resultset('Permission')->find_or_create( { role_id      => $r->id,
                                                                    typeobj_id   => $typeobj->id,
                                                                    obj_id       => $obj->id,
                                                                    operation_id => $op->id,
                                                                    value        => $perm->{value},
                                                                    inheritable  => $inheritable,
                                                                })
                    or die "Can not build permission !";

            }
            else {
                die "typeobj " . $perm->{typeobj} . ' is unknown ... for moment'
            }

        }
    }

}

sub is_exist{
    my $self = shift;
    my $name = shift;
    my $var = shift;

    die "'$name' is not a HASH !\n" if (! ref($var) eq 'HASH');
    die "the $name' has no name !\n" if (! defined $var->{name});
}

no Moose::Role;

1;
