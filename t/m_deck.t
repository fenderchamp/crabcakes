
use CrabCakes::Model::Deck;
use Test::More no_plan;
use Test::Exception;

#buddha — 'Holding onto anger is like drinking poison and expecting the other person to die.'

my $a;
$DB::single=1;
my $deck = CrabCakes::Model::Deck->new();

is( $deck->size, 52, '52 in the deck' );
ok( $deck->shuffled, 'deck is shuffled by default' );
$deck->sort_it(); 
ok( $deck->sorted, 'deck is shuffled by default' );
is( $deck->first_card->string, 'AH', 'deck is shuffled by default' );
is( $deck->last_card->string,  'AS', 'deck is shuffled by default' );

