package CrabCakes::Control::Dealer;

use CrabCakes::Model::Game;

use Mouse;

has game => ( 
   is => 'ro', 
   isa => 'Object' 
);


sub deal { 

   my ($self,%args)=@_;

   #my $database = $args{database};
   $self->game($self->find_game(%args));
}

sub find_game { 

   my ($self,%args)=@_;

   if ( 0 ) {
   } else {
      my $self->game(CrabCakes::Model::Game->new(game_size=>$args{game_size}));
   }
}

   #if ( $database->collection(pending_game_size)


#   return($self->game->next_player() );


1;
