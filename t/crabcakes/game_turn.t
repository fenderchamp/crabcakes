use strict;
use FindBin;
use lib "$FindBin::Bin/../../lib";

use CrabCakes::Game;
use CrabCakes::Deck;
use CrabCakes::Hand;

use Test::More;
use Test::Exception;

#basic game initializers

#two player game
#default 2 player game
my $game = new_game();

my $deck = CrabCakes::Deck->new();

is( $game->player_count, 2, 'two players by default' );

isa_ok( $game->player(0), 'CrabCakes::Player', 'first player Found' );
isa_ok( $game->player(1), 'CrabCakes::Player', 'second player Found' );

my $player1 = $game->player(0);
my $player2 = $game->player(1);

#test the card fetching syntax
my @junk;
while ( my $card = $player1->hand->next_card ) {
    push @junk, $card;
}
while ( my $card = $player2->hand->next_card ) {
    push @junk, $card;
}
is( $player1->hand->size, 0, 'all gone' );
is( $player2->hand->size, 0, 'all gone' );

$player1->add_card( $deck->get_card('2H') );
$player1->add_card( $deck->get_card('5C') );
$player1->add_card( $deck->get_card('5H') );
$player1->add_card( $deck->get_card('8H') );
$DB::single = 1;

ok( $player1->has_card_in_hand('2H'), '2H found p1' );
ok( $player1->has_card_in_hand('5C'), '5C found p1' );
ok( $player1->has_card_in_hand('5H'), '5H found p1' );
ok( $player1->has_card_in_hand('8H'), '8H found p1' );

$player2->add_card( $deck->get_card('2S') );
$player2->add_card( $deck->get_card('5D') );
$player2->add_card( $deck->get_card('5S') );
$player2->add_card( $deck->get_card('7H') );

ok( $player2->has_card_in_hand('2S'), '2S found p2' );
ok( $player2->has_card_in_hand('5D'), '5D found p2' );
ok( $player2->has_card_in_hand('5S'), '5S found p2' );
ok( $player2->has_card_in_hand('7H'), '7H found p2' );

is( $game->player_with_the_most(2), undef,    'both gots a two' );
is( $game->player_with_the_most(5), undef,    'both gots 2 fives' );
is( $game->player_with_the_most(8), $player1, 'ones gots more eights' );
is( $game->player_with_the_most(7), $player2, 'twos gots more sevenssss' );

is( $game->unready_player_count, 2, 'both unready still' );
is( $game->ready_player_count,   0, 'none ready' );
is( $game->starting_player(), 'PlayersNotReady',
    'everybody ain\'t ready boss' );
ok( !$game->can_start_gameplay, 'not can_start_gameplay 2' );

$player1->is_ready(1);
is( scalar @{ $game->unready_players }, 1, 'one player unready still' );
ok( !$game->can_start_gameplay, 'not can_start_gameplay 1' );

$player2->is_ready(1);
is( scalar @{ $game->unready_players }, 0, 'both ready now still' );
ok( $game->can_start_gameplay,     'can_start_gameplay 2' );
ok( $game->can('starting_player'), 'starting_player attribute found' );

is( $game->turn->progress, $game->turn->NEW, 'NEW' );

is( $game->starting_player, $player1->id, "starting player is player1" );
$game->take_turn( id => $player1->id );
is( $player1->hand->size, 5, 'player1 picked up a card' );

is( $game->turn->progress, $game->turn->DREW, 'DREW' );

$DB::single = 1;

#throws_ok { $game->take_turn(card=>'8C', id => $player1->id) }, 'NO::CARD', 'not found');
$game->take_turn( card => '8H', id => $player1->id );

is( $game->discards->size,                   1,    'one card in the pile' );
is( $game->discards->top_card->abbreviation, '8H', 'card was played' );
is( $player1->hand->size,                    4,    'player1 pitched a card' );

is( $game->turn->progress, $game->turn->PLAYED, 'PLAYED' );
$game->take_turn( id => $player1->id );

is( $game->turn->progress,                 $game->turn->NEW, 'NEW' );
is( $game->get_player_whos_turn_it_is->id, $player2->id,     "switched turns" );
is( $game->turns_taken,                    1,                "one turn taken" );

$player1 = $game->player(0);
$player2 = $game->player(1);

is( $player1->is_turn, 0, 'player1s not turn' );
is( $player2->is_turn, 1, 'player2s turn' );

#$game->pretty(1);
#my $string = $game->to_json;
#print "$string\n";

done_testing();

sub new_game {
    my %args = @_;
    my $game = CrabCakes::Game->new(%args);
    isa_ok( $game,          'CrabCakes::Game', 'game created' );
    isa_ok( $game->players, 'ARRAY',           'players found' );
    is( $game->player_count(), $game->game_size(),
        'players matches game_size found' );
    return $game;
}

exit;

