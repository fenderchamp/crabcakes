use strict;
use CrabCakes::Model::Discards;
use Test::More 'no_plan';
use Test::Exception;

#buddha — 'Holding onto anger is like drinking poison and expecting the other person to die.'

my $a;
my $discards = CrabCakes::Model::Discards->new();

is( $discards->size, 0, '0 in the deck' );
isa_ok( $discards->cards, 'ARRAY', 'empty ...really I prefere Barney Fife' );

exit;

