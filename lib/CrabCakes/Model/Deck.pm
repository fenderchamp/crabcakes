package CrabCakes::Model::Deck;

use CrabCakes::Control::CardMaker;

use Mouse;
use Array::Shuffle;

has 'cards' => (
       traits     => ['Array'],
       is         => 'rw',
       isa        => 'ArrayRef',
       builder    => 'new_deck',
       handles    => {
           all_cards    => 'elements',
           add_card     => 'push',
           filter_cards => 'grep',
           first_card => 'first',
           last_card  => 'first',
           size       => 'count',
           _shuffle_deck => 'shuffle'
       },
);

has 'sorted' => ( 
   isa => 'Bool',
   is => 'rw',
   default =>sub { return 1 }
);

sub BUILD {
   my ($self)=@_;
   $self->shuffle_it();
   $self->sorted(0);
}

sub shuffled {
  return !($_[0]->sorted);
};

sub new_deck {
   my ($self,@args)=@_;

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
   $self->sorted(1);
   return $deck;

}

sub shuffle_it{ 
   my ($self,@args)=@_;
$DB::single=1;
$self->_shuffle_deck();
#   $self->cards(
#);
   $self->sorted(0);
}

1;

