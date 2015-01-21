package CrabCakes::Web;

use CrabCakes::Control::Dealer;
use CrabCakes::Control::MongoDb;
use Dancer ':syntax';
use Dancer::Plugin::Mongo;

our $VERSION = '0.1';

get '/help' => sub {
    template 'index';
};

get '/' => sub {
    send_file '/crabcakes.html'
};

get '/klondike' => sub {
    send_file '/klondike.html'
};

get '/crabcakes/two_player_game' => sub {

   my $database = get_database();
   my $dl=CrabCakes::Control::Dealer->new(
      database  => $database,
      game_size => 2
   ); 
   $dl->deal();
};

#curl localhost:3000/crabcakes/three_player_game;

get '/crabcakes/three_player_game' => sub {

   my $database = get_database();
   my $dl = CrabCakes::Control::Dealer->new(
      database  => $database,
      game_size => 3
   );
   $dl->deal();
};

sub get_database {
   return  CrabCakes::Control::MongoDb->new(
      database => mongo->get_database('crabcakes')
   );
};

true;
