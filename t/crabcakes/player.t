use strict;

use FindBin;
use lib "$FindBin::Bin/../../lib";
use lib "$FindBin::Bin/../../t/lib";

use CrabCakes::Player;
use CrabCakes::Deck;
use Test::Cards::JSON qw(copy_by_json);

use Test::More;
use Test::Exception;

my $player = CrabCakes::Player->new();
my $new    = copy_by_json($player);

player_test($player);
player_test($new);

done_testing();

exit;

sub player_test {

    my $player = shift;

    isa_ok( $player, 'CrabCakes::Player', 'player created' );
    is( $player->is_ready,         0, 'player is ready, NO!' );
    is( $player->is_turn,          0, 'player is_turn falso' );
    is( $player->crab_cakes_count, 4, 'count 4' );
    isa_ok( $player->crab_cakes, 'ARRAY', 'crab_cakes is an ARRAY' );

    isa_ok( $player->get_crab_cake(0), 'CrabCakes::CrabCake', '0 crab_cake' );
    is( $player->crab_cakes_count, 4, 'count 4' );

    isa_ok( $player->get_crab_cake(1), 'CrabCakes::CrabCake', '1 crab_cake' );
    is( $player->crab_cakes_count, 4, 'count 4' );

    isa_ok( $player->get_crab_cake(2), 'CrabCakes::CrabCake', '2 crab_cake' );
    is( $player->crab_cakes_count, 4, 'count 4' );

    isa_ok( $player->get_crab_cake(3), 'CrabCakes::CrabCake', '3 crab_cake' );
    is( $player->crab_cakes_count, 4, 'count 4' );

    my $cc = $player->get_crab_cake(0);
    isa_ok( $cc, 'CrabCakes::CrabCake', 'pulled 0 crab_cake' );
    is( $player->crab_cakes_count, 4, 'count 4' );

    isa_ok( $player->hand, 'CrabCakes::Hand', 'empty hand' );
    ok( $player->can('card_to_crabcake'), 'player can card_to_crabcake' );

    my $new = copy_by_json($player);    #copy empty player

    my $deck = CrabCakes::Deck->new();

    my $ctr = 0;
    foreach my $card (qw(AS AH AD AC)) {
        $player->add_card( $deck->get_card($card) );
        ok( $player->hand->has_card($card),   "has $card" );
        ok( $player->has_card_in_hand($card), "has $card" );
        is( $player->hand_size, ++$ctr, "player has $ctr cards" );
    }
    $new = copy_by_json($player);       #copy player who has been dealt a hand

    $player->get_crab_cake(0)->bottom_card( $deck->get_card('ks') );
    $player->get_crab_cake(0)->top_card( $deck->get_card('qs') );

    $player->get_crab_cake(1)->bottom_card( $deck->get_card('kh') );
    $player->get_crab_cake(1)->top_card( $deck->get_card('qh') );

    $player->get_crab_cake(2)->bottom_card( $deck->get_card('kd') );
    $player->get_crab_cake(2)->top_card( $deck->get_card('qd') );

    $player->get_crab_cake(3)->bottom_card( $deck->get_card('kc') );
    $player->get_crab_cake(3)->top_card( $deck->get_card('qc') );

    $new = copy_by_json($player);    #copy player who has crabcakes and a hand

    #see if the cakes are the same
    for ( $player, $new ) {
        is( $_->get_crab_cake(0)->bottom_card->abbreviation,
            'KS', 'KS cc 0 bottom' );
        is( $_->get_crab_cake(1)->bottom_card->abbreviation,
            'KH', 'KH cc 1 bottom' );
        is( $_->get_crab_cake(2)->bottom_card->abbreviation,
            'KD', 'KD cc 3 bottom' );
        is( $_->get_crab_cake(3)->bottom_card->abbreviation,
            'KC', 'KC cc 4 bottom' );

        is( $_->get_crab_cake(0)->top_card->abbreviation, 'QS', 'QS cc 0 top' );
        is( $_->get_crab_cake(1)->top_card->abbreviation, 'QH', 'QH cc 1 top' );
        is( $_->get_crab_cake(2)->top_card->abbreviation, 'QD', 'QD cc 3 top' );
        is( $_->get_crab_cake(3)->top_card->abbreviation, 'QC', 'QC cc 4 top' );
    }

    $player->card_to_crabcake( 'AS', 0 );
    $player->card_to_crabcake( 'AH', 1 );
    $player->card_to_crabcake( 'AD', 2 );
    $player->card_to_crabcake( 'AC', 3 );

    $new = copy_by_json($player);    #copy player who has shifted the crabcakes

    for ( $player, $new ) {

        foreach my $card (qw(QS QH QD QC)) {
            ok( $_->hand->has_card($card),   "has $card" );
            ok( $_->has_card_in_hand($card), "has $card" );
            is( $_->hand_size, 4, 'player has 4 cards' );
        }

        is( $_->get_crab_cake(0)->top_card->abbreviation,
            'AS', 'AS cc 0 bottom' );
        is( $_->get_crab_cake(1)->top_card->abbreviation,
            'AH', 'AH cc 1 bottom' );
        is( $_->get_crab_cake(2)->top_card->abbreviation,
            'AD', 'AD cc 3 bottom' );
        is( $_->get_crab_cake(3)->top_card->abbreviation,
            'AC', 'AC cc 4 bottom' );

        is( $_->get_crab_cake(0)->bottom_card->abbreviation,
            'KS', 'KS cc 0 bottom' );
        is( $_->get_crab_cake(1)->bottom_card->abbreviation,
            'KH', 'KH cc 1 bottom' );
        is( $_->get_crab_cake(2)->bottom_card->abbreviation,
            'KD', 'KD cc 3 bottom' );
        is( $_->get_crab_cake(3)->bottom_card->abbreviation,
            'KC', 'KC cc 4 bottom' );
    }

    $player->is_ready(1);
    $new =
      copy_by_json($player);  #copy the player after he has set himself to ready

    is( $new->is_ready,    1, 'player is ready' );
    is( $player->is_ready, 1, 'player is ready' );

}

