package CrabCakes::Model::Deck;

use CrabCakes::Control::CardMaker;

use Mouse;

has '_sorted_cards' => (
       traits     => ['Array'],
       is         => 'rw',
       isa        => 'ArrayRef',
       lazy       => 1,
       builder    => '_build_sorted_deck',
       handles    => {
           _shuffle_deck => 'shuffle'
       },
);

has 'cards' => (
       traits     => ['Array'],
       is         => 'rw',
       isa        => 'ArrayRef',
       lazy       => 1,
       builder    => '_new_deck',
       handles    => {
           all_cards    => 'elements',
           add_card     => 'push',
           filter_cards => 'grep',
           first_card => 'first',
           last_card  => 'first',
           size       => 'count',
       },
);


sub BUILD {
   my ($self)=@_;
}

sub _new_deck {
   my ($self)=@_;
   my @deck=$self->_shuffle_deck();
   return \@deck;
}

sub _build_sorted_deck {

   my ($self)=@_;

   my $deck=[];

   my $cardMaker=CrabCakes::Control::CardMaker->new;
   foreach my $suit  (qw(clubs diamonds)) { 
      for ( my $number=2;$number<=14;$number++ ){
         push @$deck, $cardMaker->card(number=>$number,suit=>$suit);
      }
   }

   foreach my $suit  (qw(hearts spades)) { 
      for ( my $number=14;$number>=2;$number-- ){
         push @$deck, $cardMaker->card(number=>$number,suit=>$suit);
      }
   }
   return $deck;

}

1;
