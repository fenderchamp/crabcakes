package CrabCakes::Control::MongoDB;

use Mouse;

use CrabCakes::Model::Game;


has database => ( 
   is => 'ro', 
   isa => 'Object', 
   required => 1 
);

sub save_game {

   my ($self,%args)=@_;

   my $game=$args{game};

   my $game_id=$game->game_id;
   my $game_json=$game->json;

   my $database=$self->database;

   $database->collection->insert({id=>$game_id,$game_json});

}

sub save_pending_game {

   my ($self,%args)=@_;

   my $game=$args{game};

   my $game_size=$game->game_size;
   my $game_json=$game->json;

   my $database=$self->database;

   my $key='pending_'.$args{game_size};

   $database->collection->insert({id=>$key,$game_json});

}

sub has_pending_game {

   my ($self,%args)=@_;
   my $game_size=$args{game_size};

   my $database=$self->database;

   my $key='pending_'.$args{game_size};
   my $game_json=$database->collection->find_one({id=>$key});
   return $game_json;
}

sub delete_pending_game {

   my ($self,%args)=@_;
   my $game_size=$args{game_size};

   my $database=$self->database;

   my $key='pending_'.$args{game_size};
   $database->collection->remove({$key});
   return $game_json;

}

1;
