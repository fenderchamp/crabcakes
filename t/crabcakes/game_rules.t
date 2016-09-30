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

$player2->add_card( $deck->get_card('2S') );
$player2->add_card( $deck->get_card('5D') );
$player2->add_card( $deck->get_card('5S') );
$player2->add_card( $deck->get_card('7H') );

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

is( $game->starting_player, $player1->id, "starting player is player1" );

$game->pretty(1);
my $string = $game->to_json;
print "$string\n";

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

