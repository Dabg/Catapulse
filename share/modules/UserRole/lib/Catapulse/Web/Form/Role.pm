package Catapulse::Web::Form::Role;

use HTML::FormHandler::Moose;
extends 'Catapulse::Web::Form::Base';

=head1 NAME

Catapulse::Web::Form::Role : Form object for the Role Controller

=head1 SYNOPSIS

Form used for role/add and role/edit actions

=head1 DESCRIPTION

Catalyst Form.

=cut

has '+language_handle' => ( builder => 'get_language_handle_from_ctx' );

has '+item_class'        => ( default => 'Role' );

has_field 'name' => (
    type             => 'Text',
    required         => 1,
    label            => 'Name',
    unique           => 1,
);

has '+unique_messages' =>    (
    default => sub {
        {name => 'Already registered'}
    }
);


__PACKAGE__->meta->make_immutable;
no HTML::FormHandler::Moose;


=head1 SEE ALSO

L<Catapulse>

=head1 AUTHOR

Daniel Brosseau, 2016, <dab@catapulse.org>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
