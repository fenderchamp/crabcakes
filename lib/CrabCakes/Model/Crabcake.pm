package CrabCakes::Model::CrabCakes;

use Mouse;

has crab_cakes=>( 
       traits     => ['Array'],
       is         => 'rw',
       isa        => 'ArrayRef',
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

