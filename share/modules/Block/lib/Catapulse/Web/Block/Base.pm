package Catapulse::Web::Block::Base;

use Moose;
use namespace::autoclean;


has ctx   =>  (is => 'rw',
               isa => 'Catapulse::Web',
              );

has block   =>  (is => 'rw',
                 isa => 'Catapulse::Web::Model::DBIC::Block',
              );


sub _process {
    my $self = shift;
    my $c    = $self->ctx;
    my $block_rs = $self->block;

    # First process
    $self->process
      if ($self->can('process'));

    # Second render template if exist
    if ( $block_rs->file) {
      my $stash_key = 'body_' . $block_rs->name;
      $c->stash->{$stash_key} = $c->view('TTBlock')->render($c, $block_rs->file);
    }
}

sub stash{
    my ($self, $var, $value) = @_;

    die "Error: $var already exist"
      if $self->ctx->stash->{$var};

    $self->ctx->stash->{$var} = $value;
}

1;
