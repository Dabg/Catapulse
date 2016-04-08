package Catapulse::Web::Form::Block;

use HTML::FormHandler::Moose;
extends 'Catapulse::Web::Form::Base';

=head1 NAME

Form object for the Block Controller

=head1 SYNOPSIS

Form used for block/add and block/edit actions

=head1 DESCRIPTION

Catalyst Form.

=cut

has '+language_handle' => ( builder => 'get_language_handle_from_ctx' );

has '+item_class'        => ( default => 'Block' );

has_field 'name' => (
    type             => 'Text',
    required         => 1,
    label            => 'Name',
);

has_field 'file' => (
    type             => 'Text',
    required         => 1,
    label            => 'File',
);



__PACKAGE__->meta->make_immutable;
no HTML::FormHandler::Moose;

1;
