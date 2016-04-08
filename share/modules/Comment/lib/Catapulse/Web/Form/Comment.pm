package Catapulse::Web::Form::Comment;

use HTML::FormHandler::Moose;
extends 'Catapulse::Web::Form::Base';

=head1 NAME

Form comment

=head1 SYNOPSIS

Form used to add comment

=head1 DESCRIPTION

Catalyst Form.

=cut

has '+language_handle' => ( builder => 'get_language_handle_from_ctx' );

has '+item_class'        => ( default => 'Comment' );

has_field 'poster' => (
    type             => 'Text',
    label            => 'Poster',
    required         => 1,
);

has_field 'page'   => (
    type             => 'Hidden',
    required         => 1,
);

has_field 'posted' => (
    type             => 'DateMDY',
);

has_field 'body'   => (
    type             => 'TextArea',
    required         => 1,
    label            => 'Body',
);


__PACKAGE__->meta->make_immutable;
no HTML::FormHandler::Moose;

1;
