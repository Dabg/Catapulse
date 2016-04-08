package Catapulse::Web::Form::User;

use HTML::FormHandler::Moose;
extends 'Catapulse::Web::Form::Base';

=head1 NAME

Form object for the User Controller

=head1 SYNOPSIS

Form used for user/add and user/edit actions

=head1 DESCRIPTION

Catalyst Form.

=cut

has '+language_handle' => ( builder => 'get_language_handle_from_ctx' );

has '+item_class'        => ( default => 'User' );

has_field 'username' => (
    type             => 'Text',
    required         => 1,
    label            => 'Username',
    unique           => 1,
);
has_field 'name' => (
    type             => 'Text',
    required         => 1,
    label            => 'Name',
);

has_field 'password' => (
    type             => 'Password',
    required         => 1,
    label            => 'Password',
);

has_field 'password_confirm'         => (
    type => 'PasswordConf',
    required         => 1,
);

has_field 'email'      => (
    type => 'Email',
    required => 1,
    label            => 'Email',
    unique => 1,
);

has_field 'tzone' => (
    type             => 'Text',
    label            => 'Timezone',
);

has '+unique_messages' =>    (
    default => sub {
        {email => 'Email already registered'}
    }
);


__PACKAGE__->meta->make_immutable;
no HTML::FormHandler::Moose;

1;
