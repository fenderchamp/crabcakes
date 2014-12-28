use strict;
use FindBin;
use lib "$FindBin::Bin/../lib";
use CrabCakes::Model::Pile;
use CrabCakes::Model::Deck;
use Test::More 'no_plan';
use Test::Exception;

#buddha — 'Holding onto anger is like drinking poison and expecting the other person to die.'

my $a;
my $pile = CrabCakes::Model::Pile->new();
my $deck = CrabCakes::Model::Deck->new();

is( $pile->size, 0, '0 in the pile' );
isa_ok( $pile->cards, 'ARRAY', 'empty ...really I prefere Barney Fife' );

foreach my $number ( 1 .. 3 ) {
    my $card         = $deck->next_card();
    my $abbreviation = $card->abbreviation();
    $pile->add_card($card);
    is( $pile->top_card->abbreviation,
        $abbreviation, "found $abbreviation on top" );
    is( $pile->size, $number, "$number in the pile" );
    is( $deck->size, ( 52 - $number ), "(52 - $number) in the deck" );

}
$DB::single = 1;

exit;

