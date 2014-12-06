use CrabCakes::Model::Game;
use Test::More no_plan;
use Test::Exception;
use strict;

#two player game

my $a;
my $game = CrabCakes::Model::Game->new();

isa_ok($game,'CrabCakes::Model::Game','game created');
isa_ok($game->players,'ARRAY','players found');

is($game->players->count,2,'two players by default');

is_ok($game->player(1),'CrabCakes::Model::Player','first player Found');
is_ok($game->player(2),'CrabCakes::Model::Player','second player Found');
ok(! $game->player(3),'no third player found');

isa_ok($game->discarded_cards,'CrabCakes::Model::Discard','discard pile Found');
is($game->discarded_cards->size,0, 'no discarded cards found');

isa_ok($game->pile,'CrabCakes::Model::Pile','new pile pile Found');
is($game->pile->size,28, '28  cards left in the discard pile two player game');

my %visibles;
foreach my $card ($game->cards_in_pile) {
   $visibles{$card->visible_to}++;
}
is($visible{nobody},28,'28 cards in pile visible to nobody');
is(scalar(keys(%visible)),1,'28 all in pile visible to nobody');

foreach $player_number (1,2) {
   my $player = $game->player($player_number);
   is_ok($player->hand,'CrabCakes::Model::Hand',"player $player_number has a hand');
   is($player->hand->size,4,"player $player_number has a 4 card hand');
   my $count=0; 
   foreach my $card ($player->cards_in_hand) {
      $count++;
      isa_ok($card, 'CrabCakes::Model::Card',"player:$player_number card:$count is a card");
      is($card->visible_to,'player',,"player:$player_number card:$count visible to playerd");
   }
   is($count,4,'examined 4 cards for player:$player_number');
   my $player->crab_cakes->count,4,'$player_number has 4 crabcakes');
   foreach my $crab_cake_number ( 1 2 3 4 ) {
      my $crabcake=$player->crab_cakes($crab_cake_number);
      isa_ok($crabcake,'CrabCakes::Model::CrabCake',"player: $player_number has $crab_cake $crab_cake_number");
      isa_ok($crabcake->top_card(),
         'CrabCakes::Model::Card',
         "player: $player_number  $crab_cake $crab_cake_number has top card"
      );
      isa_ok($crabcake->bottom_card(),
         'CrabCakes::Model::Card',
         "player: $player_number has $crab_cake $crab_cake_number has bottom card"
      );
      is($crabcake->top_card->visible_to,
         'everbody',
         "player: $player_number  $crab_cake $crab_cake_number top card visible to everybody"
      );
      is($crabcake->bottom_card->visible_to,
         'nobody',
         "player: $player_number has $crab_cake $crab_cake_number bottom card visible to nobody"
      );
   }
}


is( $deck->size, 52, '52 in the deck' );

exit;

