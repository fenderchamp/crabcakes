use strict;
use FindBin;
use lib "$FindBin::Bin/../../lib";
use lib "$FindBin::Bin/../../t/lib";

use Test::Cards::JSON qw(copy_by_json);

use CrabCakes::Discards;
use CrabCakes::Deck;

use Test::More 'no_plan';
use Test::Exception;

#buddha — 'Holding onto anger is like drinking poison and expecting the other person to die.'

my $deck     = CrabCakes::Deck->new();
my $discards = CrabCakes::Discards->new();

is( $discards->size, 0, '0 in the deck' );
isa_ok( $discards->cards, 'ARRAY', 'empty ...really I prefere Barney Fife' );

for ( 1 .. 10 ) {

    my $card = $deck->next_card;
    $discards->add_card($card);

    is( $discards->size, $_, "$_ discards" );

    is( $discards->top_card, $card, "new top card found" );

    for ( my $i = 1 ; $i < $_ ; $i++ ) {
        my $z = $i - 1;
        is( $discards->cards->[$z]->visible_to,
            'nobody', "in pile of $_: $i visible_to nobody" );
    }
    is( $discards->top_card->visible_to,
        'everybody', "everybody can see the top card" );
    is( $discards->cards->[ ( $discards->size - 1 ) ]->visible_to,
        'everybody', "everybody can see the card at $_" );
}

my $new = copy_by_json($discards);

exit;

