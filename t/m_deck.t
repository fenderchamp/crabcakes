use strict;
use CrabCakes::Model::Deck;
use Test::More 'no_plan';
use Test::Exception;

#buddha — 'Holding onto anger is like drinking poison and expecting the other person to die.'

my $a;
my $deck = CrabCakes::Model::Deck->new();

$DB::single=1;
is( $deck->size, 52, '52 in the deck' );

exit;

