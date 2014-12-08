use strict;
use CrabCakes::Model::Game;
use Test::More 'no_plan';
use Test::Exception;

#basic game initializers


#two player game
#default 2 player game 
my $game=new_game();
is($game->player_count,2,'two players by default');
isa_ok($game->player(0),'CrabCakes::Model::Player','first player Found');
isa_ok($game->player(1),'CrabCakes::Model::Player','second player Found');
ok(! $game->player(2),'no third player found');

# 3 player game 
my $game=new_game(game_size=>3);
is($game->player_count,3,'three players by default');
isa_ok($game->player(0),'CrabCakes::Model::Player','first player Found');
isa_ok($game->player(1),'CrabCakes::Model::Player','second player Found');
isa_ok($game->player(2),'CrabCakes::Model::Player','second player Found');
ok(! $game->player(3),'no fourth player found');

#invalid sizes

dies_ok ( sub { my $game=new_game(game_size=>1)} ,'invalid game size 1 dies');
dies_ok ( sub { my $game=new_game(game_size=>4)} ,'invalid game size 1 dies');

isa_ok($game->discards,'CrabCakes::Model::Discards','discard pile Found');
is($game->discards->size,0, 'no discarded cards found');

isa_ok($game->pile,'CrabCakes::Model::Pile','draw_from_stack pile Found');
is($game->pile->size,28, '28  cards to draw from');

my %visibles;
foreach my $card ($game->cards_in_pile) {
   $visibles{$card->visible_to}++;
}

exit;

is($visibles{nobody},28,'28 cards in pile visible to nobody');
is(scalar(keys(%visibles)),1,'28 all in pile visible to nobody');

foreach my $player_number (1,2) {
   my $player = $game->player($player_number);
   is_ok($player->hand,'CrabCakes::Model::Hand',"player $player_number has a hand");
   is($player->hand->size,4,"player $player_number has a 4 card hand");
   my $count=0; 
   foreach my $card ($player->cards_in_hand) {
      $count++;
      isa_ok($card, 'CrabCakes::Model::Card',"player:$player_number card:$count is a card");
      is($card->visible_to,'player',,"player:$player_number card:$count visible to playerd");
   }
   is($count,4,'examined 4 cards for player:$player_number');
   is($player->crab_cakes->count,4,"$player_number has 4 crab cakes");
   foreach my $crab_cake_number (1,2,3,4) {
      my $crab_cake=$player->crab_cakes($crab_cake_number);
      isa_ok($crab_cake,'CrabCakes::Model::CrabCake',"player: $player_number has crab_cake $crab_cake_number");
      isa_ok($crab_cake->top_card(),
         'CrabCakes::Model::Card',
         "player: $player_number  $crab_cake $crab_cake_number has top card"
      );
      isa_ok($crab_cake->bottom_card(),
         'CrabCakes::Model::Card',
         "player: $player_number has $crab_cake $crab_cake_number has bottom card"
      );
      is($crab_cake->top_card->visible_to,
         'everbody',
         "player: $player_number crab_cake:$crab_cake_number top card visible to everybody"
      );
      is($crab_cake->bottom_card->visible_to,
         'nobody',
         "player: $player_number has crab_cake $crab_cake_number bottom card visible to nobody"
      );
   }
}

sub new_game {
   my %args = @_;
   my $game = CrabCakes::Model::Game->new(%args);
   isa_ok($game,'CrabCakes::Model::Game','game created');
   isa_ok($game->players,'ARRAY','players found');
   is($game->player_count(),$game->game_size(),'players matches game_size found');
   return $game;
}

exit;

