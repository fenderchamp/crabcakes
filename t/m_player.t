use strict;
use FindBin;
use lib "$FindBin::Bin/../lib";
use CrabCakes::Model::Player;
use Test::More 'no_plan';
use Test::Exception;
use CrabCakes::Model::Deck;

my $player = CrabCakes::Model::Player->new( player_counter => 0 );
isa_ok( $player, 'CrabCakes::Model::Player', 'player created' );
is( $player->played, 0, 'player not ready' );
is( $player->joined, 0, 'player no joined' );
is( $player->crab_cakes_count, 4, 'count 4' );
isa_ok( $player->crab_cakes, 'ARRAY', 'crab_cakes is an ARRAY' );

isa_ok( $player->get_crab_cake(0), 'CrabCakes::Model::CrabCake',
    '0 crab_cake' );
is( $player->crab_cakes_count, 4, 'count 4' );

isa_ok( $player->get_crab_cake(1), 'CrabCakes::Model::CrabCake',
    '1 crab_cake' );
is( $player->crab_cakes_count, 4, 'count 4' );

isa_ok( $player->get_crab_cake(2), 'CrabCakes::Model::CrabCake',
    '2 crab_cake' );
is( $player->crab_cakes_count, 4, 'count 4' );

isa_ok( $player->get_crab_cake(3), 'CrabCakes::Model::CrabCake',
    '3 crab_cake' );
is( $player->crab_cakes_count, 4, 'count 4' );

my $cc = $player->get_crab_cake(0);
isa_ok( $cc, 'CrabCakes::Model::CrabCake', 'pulled 0 crab_cake' );
is( $player->crab_cakes_count, 4, 'count 4' );

isa_ok( $player->hand, 'CrabCakes::Model::Hand', 'empty hand' );
ok( $player->can('card_to_crabcake'), 'player can card_to_crabcake' );

my $deck = CrabCakes::Model::Deck->new();

my $ctr = 0;
foreach my $card (qw(AS AH AD AC)) {
    $player->add_card( $deck->get_card($card) );
    ok( $player->hand->has_card($card),   "has $card" );
    ok( $player->has_card_in_hand($card), "has $card" );
    is( $player->hand_size, ++$ctr, "player has $ctr cards" );
}

$player->get_crab_cake(0)->bottom_card( $deck->get_card('ks') );
$player->get_crab_cake(0)->top_card( $deck->get_card('qs') );

$player->get_crab_cake(1)->bottom_card( $deck->get_card('kh') );
$player->get_crab_cake(1)->top_card( $deck->get_card('qh') );

$player->get_crab_cake(2)->bottom_card( $deck->get_card('kd') );
$player->get_crab_cake(2)->top_card( $deck->get_card('qd') );

$player->get_crab_cake(3)->bottom_card( $deck->get_card('kc') );
$player->get_crab_cake(3)->top_card( $deck->get_card('qc') );

is( $player->get_crab_cake(0)->bottom_card->abbreviation,
    'KS', 'KS cc 0 bottom' );
is( $player->get_crab_cake(1)->bottom_card->abbreviation,
    'KH', 'KH cc 1 bottom' );
is( $player->get_crab_cake(2)->bottom_card->abbreviation,
    'KD', 'KD cc 3 bottom' );
is( $player->get_crab_cake(3)->bottom_card->abbreviation,
    'KC', 'KC cc 4 bottom' );

is( $player->get_crab_cake(0)->top_card->abbreviation, 'QS', 'QS cc 0 top' );
is( $player->get_crab_cake(1)->top_card->abbreviation, 'QH', 'QH cc 1 top' );
is( $player->get_crab_cake(2)->top_card->abbreviation, 'QD', 'QD cc 3 top' );
is( $player->get_crab_cake(3)->top_card->abbreviation, 'QC', 'QC cc 4 top' );

$player->card_to_crabcake( 'AS', 0 );
$player->card_to_crabcake( 'AH', 1 );
$player->card_to_crabcake( 'AD', 2 );
$player->card_to_crabcake( 'AC', 3 );

foreach my $card (qw(QS QH QD QC)) {
    ok( $player->hand->has_card($card),   "has $card" );
    ok( $player->has_card_in_hand($card), "has $card" );
    is( $player->hand_size, 4, 'player has 4 cards' );
}

is( $player->get_crab_cake(0)->top_card->abbreviation, 'AS', 'AS cc 0 bottom' );
is( $player->get_crab_cake(1)->top_card->abbreviation, 'AH', 'AH cc 1 bottom' );
is( $player->get_crab_cake(2)->top_card->abbreviation, 'AD', 'AD cc 3 bottom' );
is( $player->get_crab_cake(3)->top_card->abbreviation, 'AC', 'AC cc 4 bottom' );

is( $player->get_crab_cake(0)->bottom_card->abbreviation,
    'KS', 'KS cc 0 bottom' );
is( $player->get_crab_cake(1)->bottom_card->abbreviation,
    'KH', 'KH cc 1 bottom' );
is( $player->get_crab_cake(2)->bottom_card->abbreviation,
    'KD', 'KD cc 3 bottom' );
is( $player->get_crab_cake(3)->bottom_card->abbreviation,
    'KC', 'KC cc 4 bottom' );

#dies_ok(sub {my $player = CrabCakes::Model::Player->new(player_counter=>3)},'new player player_counter 3 out of range');

exit;

