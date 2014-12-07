package CrabCakes::Model::Game;

use  CrabCakes::Model::Player;

use Mouse;

use Mouse::Util::TypeConstraints;
   enum 'GameSizeType' => (2,3);
no Mouse::Util::TypeConstraints;

has 'game_size' => (
       is         => 'rw',
       isa        => 'GameSizeType',
       lazy       => 1,
       default    => sub { return 2 }
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

