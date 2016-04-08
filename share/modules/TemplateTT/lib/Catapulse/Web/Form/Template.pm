package Catapulse::Web::Form::Template;

use HTML::FormHandler::Moose;
extends 'Catapulse::Web::Form::Base';

=head1 NAME

Form object for the Template Controller

=head1 SYNOPSIS

Form used for template/add and template/edit actions

=head1 DESCRIPTION

Catalyst Form.

=cut

has '+language_handle' => ( builder => 'get_language_handle_from_ctx' );

has '+item_class'        => ( default => 'Template' );

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

has_field 'wrapper' => (
    type             => 'Text',
    required         => 1,
    label            => 'Wrapper',
);


__PACKAGE__->meta->make_immutable;
no HTML::FormHandler::Moose;

1;
