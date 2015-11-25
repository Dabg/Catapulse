package Catapulse::Web::Form::Page;

use HTML::FormHandler::Moose;
extends 'Catapulse::Web::Form::Base';
with 'HTML::FormHandler::Widget::Theme::Bootstrap';

=head1 NAME

Form object for the Page Controller

=head1 SYNOPSIS

Form used for page/add and page/edit actions

=head1 DESCRIPTION

HTML::FormHandler Form.

=cut

has '+language_handle' => ( builder => 'get_language_handle_from_ctx' );

has '+item_class'        => ( default => 'Page' );

has_field 'title' => (
    type             => 'Text',
    required         => 1,
    label            => 'Title',
);

has_field 'type' => (
    type     => 'Select',
  #  required => 1,
    label    => 'Type',
);

has_field 'template' => (
    type     => 'Select',
    required => 1,
    label    => 'Template',
);

has_field 'name' => (
    type  => 'Hidden',
);

has_field 'ops_to_access' => (
    type         => 'Multiple',
    widget       => 'checkbox_group',
    label_column => 'name',
    label        => 'The operations to access the page',
);


__PACKAGE__->meta->make_immutable;
no HTML::FormHandler::Moose;

1;
