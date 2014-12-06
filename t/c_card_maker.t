
use CrabCakes::Control::CardMaker;

use Test::More no_plan;

my $cm = CrabCakes::Control::CardMaker->new();
isa_ok( $cm, 'CrabCakes::Control::CardMaker' );

my $card = $cm->card( suit => 'diamonds', number => '2' );
isa_ok( $card, 'CrabCakes::Model::Card' );

