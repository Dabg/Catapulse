package Catapulse::Web::PageFactory;

use Moose;
use namespace::autoclean;
use Catapulse::Web::Block;

has template   =>  (is => 'rw',
                    isa => 'Catapulse::Web::Model::DBIC::Template',
                    lazy_build => 1,
                    required => 1,
                 );

has ctx   =>  (is => 'rw',
               isa => 'Catapulse::Web',
               required => 1,
              );

has blocks => (
               is         => 'rw',
               isa => 'HashRef',
               lazy_build => 1,
              );


sub _build_blocks {
  my $self = shift;

  my $blocks = {};
  foreach my $b_rs ($self->template->blocks->actived) {
    my $block_class =  "Catapulse::Web::Block::" . ucfirst($b_rs->name);
    my $block = Catapulse::Web::Block->new( ctx   => $self->ctx,
                                            class => $block_class,
                                          );
    $blocks->{$b_rs->name} = $block->class->new(ctx => $self->ctx, block => $b_rs);
  }
  return $blocks;
}


sub process {
  my $self = shift;


   my $blocks = $self->blocks;
   foreach my $k (keys %$blocks) {
     $blocks->{$k}->_process;
   }
}

1;
