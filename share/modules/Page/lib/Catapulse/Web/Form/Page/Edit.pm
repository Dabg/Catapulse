package Catapulse::Web::Form::Page::Edit;

use HTML::FormHandler::Moose;
extends 'Catapulse::Web::Form::Page';

has_field 'active' => (
      type => 'Select',
      widget => 'radio_group',
      required => 1,
      options => [
                  { value => 0, label => 'No'},
                  { value => 1, label => 'Yes'} ]
);

no HTML::FormHandler::Moose;
__PACKAGE__->meta->make_immutable;
1;
