use strict;
use warnings;
use DBIx::Class::Migration::RunScript;

migrate {
  my $self = shift;

  my $schema = $self->schema;

  #-------------------------------------#
  #           Templates
  #-------------------------------------#
  my @templates = $schema->populate('Template', [
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


  #-------------------------------------#
  #            Block
  #-------------------------------------#
    $schema->populate('Block', [
        [ qw/  name            file                       active/ ],
        [      'navbar',       'blocks/navbar.tt',        1       ],
        [      'breadcrumbs',  'blocks/breadcrumbs.tt',   1       ],
        [      'message',      'blocks/messages.tt',      1       ],
        [      'content',      'blocks/content.tt',       1       ],
        [      'sidebar',      'blocks/sidebar.tt',       1       ],
        [      'footer',       'blocks/footer.tt',        1       ],
        [      'querylog',     'blocks/querylog.tt',      1       ],
        [      'links',        'blocks/links.tt',         1       ],
        [      'comment',      'blocks/comment.tt',       1       ],
        [      'last_comments','blocks/last_comments.tt', 1       ],

    ]);

  #-------------------------------------#
  #    Templates / Blocks
  #-------------------------------------#
  my %tmpl_blcks;
  $tmpl_blcks{Main}     = [ 'navbar', 'breadcrumbs', 'message', 'content', 'comment', 'sidebar', 'querylog', 'footer' ];
  $tmpl_blcks{Blog}     = [ 'sidebar', 'links', 'last_comments' ];
  $tmpl_blcks{Article}  = [ 'sidebar' ];


  foreach my $tmpl (@templates) {
      foreach my $t ( @{$tmpl_blcks{$tmpl->name}} ) {
          $tmpl->add_to_blocks({name => $t});
    }

  }

};
