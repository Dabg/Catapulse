package Catapulse::Web::Form::User::Edit;

use HTML::FormHandler::Moose;
extends 'Catapulse::Web::Form::User';

has_field 'active' => (
      type => 'Select',
      widget => 'radio_group',
      required => 1,
      options => [
                  { value => 0, label => 'No'},
                  { value => 1, label => 'Yes'} ]
);

has_field 'roles' => (
    type         => 'Multiple',
    widget       => 'checkbox_group',
    label_column => 'name',
    label        => 'Roles',
);

has_field 'submit' => (
    type      => 'Submit',
    value     => 'Update',
    element_class => ['btn'],
);

no HTML::FormHandler::Moose;
__PACKAGE__->meta->make_immutable;
1;
