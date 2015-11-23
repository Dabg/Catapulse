package Catalyst::Plugin::Role::FlashMethods;

use MooseX::Role::Parameterized;

parameter 'flash_elements', isa => 'ArrayRef[Str]', required => 1;

requires 'flash';

role
{
    my $p = shift;

    for my $element (@{ $p->flash_elements })
    {
        method "add_${element}" => sub
        {
            my $self = shift;
            push @{ $self->flash->{ $element . 's' } }, @_;
        };
    }
};

1;
