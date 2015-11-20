package Catapulse::Web::Form::Register;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';
with 'HTML::FormHandler::Render::Table';

has '+item_class'            => ( default => 'User' );

has_field 'username' => ( type => 'Text',
                          label => 'Username',
                          required => 1,
                          required_message => 'You must enter a username' );

has_field 'name'     => ( type => 'Text',
                          label => 'Name',
                          required => 0,
                          required_message => 'You must enter a name' );

has_field 'email'    => (
                         type     => 'Email',
                         required => 1,
                         unique   => 1);

has_field 'website'  => ( type => 'Text' );
has_field 'password' => ( type => 'Password',
                          label => 'Password',
                          minlength => 6,
                          required => 1,
                          required_message => 'You must enter a password' );

has_field 'password_confirm' => ( type => 'PasswordConf' );
has_field 'submit'   => ( type => 'Submit', value => 'Register' );


# Insert basic role record into user_roles table on registration
after 'update_model' => sub {
    my $self = shift;

    # XXX : Externaliser role_id et revoir user_roles_test
    #$self->item->update_or_create_related('user_roles_test', { role_id => 2});
};

no HTML::FormHandler::Moose;
__PACKAGE__->meta->make_immutable;

1
