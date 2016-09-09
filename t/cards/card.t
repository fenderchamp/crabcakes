use strict;
use FindBin;
use lib "$FindBin::Bin/../../lib";
use lib "$FindBin::Bin/../../t/lib";

use Cards::Card;

use Test::More;
use Test::Exception;

use Test::Cards::JSON qw (copy_by_json);

#buddha — 'Holding onto anger is like drinking poison and expecting the other person to die.'

dies_ok { my $card = Cards::Card->new() } 'dies new no args';

dies_ok { my $card = Cards::Card->new( number => 2 ) }
'dies only number no suit';

dies_ok { my $card = Cards::Card->new( number => 19, suit => 'diamonds' ) }
'dies only bad number good suit';

dies_ok { my $card = Cards::Card->new( number => 2, suit => 'dime' ) }
'dies good number bad suit';

$DB::single = 1;
my $card = card_test( 2, 'diamonds' );
my $new = copy_by_json($card);
$card = card_test( 2, 'hearts' );
my $new = copy_by_json($card);
$card = card_test( 2, 'spades' );
my $new = copy_by_json($card);
$card = card_test( 2, 'clubs' );
my $new = copy_by_json($card);

done_testing;
exit;

sub card_test {

    my ( $number, $suit ) = @_;
    my $card = Cards::Card->new(
        number => $number,
        suit   => $suit
    );

    isa_ok( $card, 'Cards::Card' );
    is( $card->visible_to(), 'nobody', 'visible_to defaulted to nobody' );
    is( $card->suit,         $suit,    "$suit is right" );
    is( $card->number,       $number,  "$number is right" );
    return $card;
}

