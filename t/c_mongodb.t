use strict;

use FindBin;
use lib "$FindBin::Bin/../lib";

use MongoDB;
use Test::More 'no_plan';

use CrabCakes::Control::MongoDB;
use CrabCakes::Model::Game;

my $database_client=MongoDB::MongoClient->new(
   host=> "localhost",
   port=> "27017",
   database_name=> "crabcakes"
);

ok($database_client,'something returned from MondoDB::MongoClient->new');
isa_ok($database_client,'MongoDB::MongoClient','MongoDB Client created');

my $database=$database_client->get_database('crabcakes');
isa_ok($database,'MongoDB::Database','MongoDB::Database return by get_database');

my $two_player_game=CrabCakes::Model::Game->new(game_size=>2);
isa_ok($two_player_game,'CrabCakes::Model::Game','two player game');

my $three_player_game=CrabCakes::Model::Game->new(game_size=>3);
isa_ok($three_player_game,'CrabCakes::Model::Game','three player game');

my $c_database=CrabCakes::Control::MongoDB->new(database=>$database);

isa_ok($c_database, 'CrabCakes::Control::MongoDB','created CrabCakes::Control::MongoDB');

