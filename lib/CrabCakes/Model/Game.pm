package CrabCakes::Model::Game;
use Mouse;

use  CrabCakes::Model::Deck;
use  CrabCakes::Model::Discards;
use  CrabCakes::Model::Pile;
use  CrabCakes::Model::Player;

use  CrabCakes::Model::Player;

use Mouse::Util::TypeConstraints;
   enum 'GameSizeType' => (2,3);
no Mouse::Util::TypeConstraints;

has 'discards' => (
       is         => 'rw',
       isa        => 'CrabCakes::Model::Discards',
       lazy       => 1,
       default    => sub { CrabCakes::Model::Discards->new() }
);

has 'game_size' => (
       is         => 'rw',
       isa        => 'GameSizeType',
       lazy       => 1,
       default    => sub { return 2 }
);

has 'pile' => (
       is         => 'rw',
       isa        => 'CrabCakes::Model::Pile',
       lazy       => 1,
       default    => sub { CrabCakes::Model::Pile->new() }
);

has 'players' => (
       traits     => ['Array'],
       is         => 'rw',
       isa        => 'ArrayRef',
       lazy       => 1,
       builder    => '_players',
       handles    => {
           all_players    => 'elements',
           add_player     => 'push',
           player_count   => 'count',
           player => 'get',
       },
);


sub BUILD {
   my ($self)=@_;
   my $deck=CrabCakes::Model::Deck->new(); 
   for( my $hand=0;$hand<4;$hand++ ) {
      for( my $i=0;$i<$self->game_size;$i++ ) {
         $self->player($i)->get_crab_cake($hand)->add_bottom_card($deck->next_card);
         $self->player($i)->get_crab_cake($hand)->add_top_card($deck->next_card);
         $self->player($i)->take_card($deck->next_card);
      }
   }
   $self->pile->cards($deck->cards());

}

sub _players {
   my ($self,%args) =(@_);
   my $counter=0;
   my $players;
   while ( $counter < $self->game_size ) {
      $counter++;
      push @$players, CrabCakes::Model::Player->new()
   }
   return  $players;
}

1;

