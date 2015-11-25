use strict;
use warnings;
use DBIx::Class::Migration::RunScript;

migrate {
  my $self = shift;

  my $schema = $self->schema;

  #-------------------------------------#
  #           Templates
  #-------------------------------------#
  $schema->populate('Template', [
        [ qw/ name      file                    wrapper      active/ ],
        [    'Main',    'templates/main.tt',    'html',      1       ],
        [    'Blog',    'templates/blog.tt',    'nowrapper', 1       ],
        [    'Article', 'templates/article.tt', 'nowrapper', 1       ],
    ]);

  #-------------------------------------#
  #           Pagetype
  #-------------------------------------#
  $schema->populate('Pagetype', [
        [ qw/  name               path     active/ ],
        [      'from_controller', '',      1       ],
        [      'wiki',            '/wiki', 1       ],
    ]);

  #-------------------------------------#
  #            Page
  #-------------------------------------#
  my $dtnow = DateTime->now;
  $schema->populate('Page', [
        [ qw/  id title            name           parent_id  type template created version  active/ ],
        [      1, 'index',         '/',           0,         2,   1,       $dtnow, undef,   1       ],
        [      2, 'default',       'default',     1,         2,   1,       $dtnow, undef,   1       ],
        [      3, 'Administration','admin',       1,         2,   1,       $dtnow, undef,   1       ],
        [      4, 'Help'          ,'Help',        1,         2,   1,       $dtnow, undef,   1       ],
    ]);

};
