use strict;
use FindBin;
use lib "$FindBin::Bin/../lib";
use CrabCakes::Model::Player;
use Test::More 'no_plan';
use Test::Exception;

my $player = CrabCakes::Model::Player->new( player_counter => 0 );
isa_ok( $player, 'CrabCakes::Model::Player', 'player created' );
is( $player->crab_cakes_count, 4, 'count 4' );
isa_ok( $player->crab_cakes, 'ARRAY', 'crab_cakes is an ARRAY' );

isa_ok( $player->get_crab_cake(0),'CrabCakes::Model::CrabCake','0 crab_cake');
is( $player->crab_cakes_count, 4, 'count 4' );

isa_ok( $player->get_crab_cake(1),'CrabCakes::Model::CrabCake','1 crab_cake');
is( $player->crab_cakes_count, 4, 'count 4' );

isa_ok( $player->get_crab_cake(2),'CrabCakes::Model::CrabCake','2 crab_cake');
is( $player->crab_cakes_count, 4, 'count 4' );

isa_ok( $player->get_crab_cake(3),'CrabCakes::Model::CrabCake','3 crab_cake');
is( $player->crab_cakes_count, 4, 'count 4' );

my $cc=$player->get_crab_cake(0);
isa_ok( $cc,'CrabCakes::Model::CrabCake','pulled 0 crab_cake');
is( $player->crab_cakes_count, 4, 'count 4' );


isa_ok( $player->hand, 'CrabCakes::Model::Hand', 'empty hand' );
is( $player->ready, 0, 'player not ready by default' );
ok( $player->can('card_to_crabcake'), 'player can card_to_crabcake' );


#dies_ok(sub {my $player = CrabCakes::Model::Player->new(player_counter=>3)},'new player player_counter 3 out of range');

exit;

