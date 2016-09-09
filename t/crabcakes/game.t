use strict;
use FindBin;
use lib "$FindBin::Bin/../../lib";
use lib "$FindBin::Bin/../../t/lib";

use Test::Cards::JSON qw(copy_by_json);

use CrabCakes::Game;
use Test::More;
use Test::Exception;

#basic game initializers

#invalid sizes
dies_ok( sub { my $game = new_game( game_size => 1 ) },
    'invalid game size 1 dies' );
dies_ok( sub { my $game = new_game( game_size => 4 ) },
    'invalid game size 1 dies' );

my $game = new_game( game_size => 3 );
three_player_test($game);
my $new = copy_by_json($game);
three_player_test($new);

#two player game
#default 2 player game
my $game = new_game();
my $new  = copy_by_json($game);

game_test($game);
game_test($new);

done_testing();

sub game_test {

    my $game = shift;

    is( $game->player_count, 2, 'two players by default' );
    isa_ok( $game->player(0), 'CrabCakes::Player', 'first player Found' );
    isa_ok( $game->player(1), 'CrabCakes::Player', 'second player Found' );
    ok( !$game->player(2), 'no third player found' );
    ok( !$game->player(3), 'no fourth player found' );

    isa_ok( $game->discards, 'CrabCakes::Discards', 'discard pile Found' );
    is( $game->discards->size, 0, 'no discarded cards found' );

    is( $game->player_count, 2, 'two players by default' );
    isa_ok( $game->deck, 'CrabCakes::Deck', 'draw_from_stack pile Found' );
    is( $game->deck->size, 28, '28  cards to draw from' );

    my %visibles;
    foreach my $card ( $game->deck->all_cards() ) {
        $visibles{ $card->visible_to }++;
    }

    is( $visibles{nobody},         28, '28 cards in deck visible to nobody' );
    is( scalar( keys(%visibles) ), 1,  '28 all in deck visible to nobody' );

    foreach my $player_number ( 0, 1 ) {

        my $player      = $game->player($player_number);
        my $same_player = $game->get_player_by_id( $player->id );
        is( $player, $same_player, 'fetch by id works' );

        isa_ok( $player->hand, 'CrabCakes::Hand',
            "player $player_number has a hand" );
        is( $player->hand->size, 4, "player $player_number has a 4 card hand" );
        my $count = 0;
        foreach my $card ( $player->hand->all_cards ) {
            $count++;
            isa_ok( $card, 'CrabCakes::Card',
                "player:$player_number card:$count is a card" );
            is( $card->visible_to, 'player',,
                "player:$player_number card:$count visible to player" );
        }
        is( $count, 4, 'examined 4 cards for player:$player_number' );
        is( $player->crab_cakes_count, 4, "$player_number has 4 crab cakes" );
        foreach my $crab_cake_number ( 0, 1, 2, 3 ) {
            my $crab_cake = $player->get_crab_cake($crab_cake_number);
            isa_ok( $crab_cake, 'CrabCakes::CrabCake',
                "player: $player_number has crab_cake $crab_cake_number" );
            isa_ok( $crab_cake->top_card(), 'CrabCakes::Card',
"player: $player_number  $crab_cake $crab_cake_number has top card"
            );
            isa_ok( $crab_cake->bottom_card(), 'CrabCakes::Card',
"player: $player_number has $crab_cake $crab_cake_number has bottom card"
            );
            is( $crab_cake->top_card->visible_to, 'everybody',
"player: $player_number crab_cake:$crab_cake_number top card visible to everybody"
            );
            is( $crab_cake->bottom_card->visible_to, 'nobody',
"player: $player_number has crab_cake $crab_cake_number bottom card visible to nobody"
            );
        }
    }
}

sub three_player_test {

    # 3 player game
    my $game = shift;
    is( $game->player_count, 3, 'three players by default' );
    isa_ok( $game->player(0), 'CrabCakes::Player', 'first player Found' );
    isa_ok( $game->player(1), 'CrabCakes::Player', 'second player Found' );
    isa_ok( $game->player(2), 'CrabCakes::Player', 'second player Found' );
}

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

