use strict;
use warnings;
use DBIx::Class::Migration::RunScript;

migrate {
  my $self = shift;

  my $schema = $self->schema;

  my $i18n_path = "lib/Catapulse/Web/I18N";

  require Locale::Maketext::Simple;
    Locale::Maketext::Simple->import(
        Decode => 1,
        Class  => 'Catapulse::Web',
        Path   => $i18n_path,
    );

  my @users = $schema->resultset('User')->search->all;
  #-------------------------------------#
  #            Content
  #-------------------------------------#
  my @content = $schema->populate(
        'Content',
        [
            [
                qw/ page version creator created body status release_date remove_date type abstract comments
                    precompiled /
            ],
            [
                1, 1, $users[1]->id, 0, loc('ui.page.welcome.message'),
                'released', 1, 1, '', '', '', loc('ui.page.welcome.message')
            ],
            [
                2, 1, $users[1]->id, 0, loc('ui.page.admin.message'),
                'released', 1, 1, '', '', ''
            ],
            [
                3, 1, $users[1]->id, 0, loc('ui.page.help.message'),
                'released', 1, 1, '', '', '', loc('help message')

            ],
        ]
    );

  $schema->resultset('Page')->update( { version => 1 } );
};
