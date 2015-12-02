package Catapulse::Web::Form::Wiki;

use HTML::FormHandler::Moose;

extends 'HTML::FormHandler';
with 'HTML::FormHandlerX::Form::JQueryValidator';
with 'HTML::FormHandler::Widget::Theme::Bootstrap';

=head1 NAME

Form object for the Wiki Controller

=head1 SYNOPSIS

Form used by wiki

=head1 DESCRIPTION

HTML::FormHandler Form.

=cut

has '+language_handle' => ( builder => 'get_language_handle_from_ctx' );

has_field 'body' => (
    type             => 'TextArea',
    required         => 1,
    label            => 'Body',
);

__PACKAGE__->meta->make_immutable;
no HTML::FormHandler::Moose;

1;
