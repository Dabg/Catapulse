package Catapulse::Web::Form::Base;

use utf8;
use HTML::FormHandler::Moose;

extends 'HTML::FormHandler::Model::DBIC';

with 'HTML::FormHandlerX::Form::JQueryValidator';
with 'HTML::FormHandler::Widget::Theme::Bootstrap';

sub get_language_handle_from_ctx {
    my $self = shift;

    return HTML::FormHandler::I18N->get_handle(
         @{ $self->ctx->languages } );
}

has_field validation_json => ( type => 'Hidden',  element_attr => { disabled => 'disabled' } );

sub default_validation_json { shift->as_escaped_json }

sub html_attributes {
    my ( $self, $field, $type, $attr ) = @_;
    if ($type eq 'label' && $field->{required}) {
        my $label = $field->{label};
        $field->{label} = "$label *" unless $label =~ /\*$/;
    }
    return $attr;
}

1;
