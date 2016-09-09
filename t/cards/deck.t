use strict;
use FindBin;
use lib "$FindBin::Bin/../../lib";
use Cards::Deck;
use Test::More 'no_plan';
use Test::Exception;

#buddha — 'Holding onto anger is like drinking poison and expecting the other person to die.'

my $a;
my $deck = Cards::Deck->new();
isa_ok( $deck, 'Cards::Deck', 'deck object created' );
is( $deck->size, 52, '52 in the deck' );

foreach my $number (qw(2 3 4 5 6 7 8 9 10 J Q K A)) {
    foreach my $suit (qw(H D C S)) {
        my $str = $number . $suit;
        ok( $deck->has_card($str), "$str found" );
    }
    is( $deck->how_many_of($number), 4 , "4 $number found" );
}

isa_ok( $deck->lowest_card, 'Cards::Card');
is ( $deck->lowest_card->number, 2,' found the two in the deck'); 
is ( $deck->lowest_number, 2,' found the two in the deck'); 

my $gt=4;
my $lt=2;
for (qw(3 4 5 6 7 8 9 10 J Q K A)) {
  is( $deck->lowest_card( gt => $_ )->number, $gt,"found the $gt in the deck lowest_card gt $_") unless ( $_ eq 'A' );
  is( $deck->highest_card( lt => $_ )->number, $lt,"found the $lt in the deck higest_card lt $_"); 
  $lt++; $gt++;
}

my $card = $deck->get_card('QH');
isa_ok( $card, 'Cards::Card', 'deck object found' );
is( $card->abbreviation, 'QH', 'the QH is found' );

throws_ok sub { $deck->has_card('QH') }, 'Cards::Error::NotFound', 'QH is not there now';
is( $deck->size, 51, '51 in the deck' );

throws_ok sub { $deck->get_card('QH') }, 'Cards::Error::NotFound', 'QH is not there now';
is( $deck->size, 51,    '51 still in the deck' );

my $card = $deck->next_card();
isa_ok( $card, 'Cards::Card', 'object found is a card' );
is( $deck->size, 50, '50 still in the deck' );

my $s = $deck->size;
my @pulled;
foreach ( 1 .. 5 ) {
    my $card = $deck->next_card();
    push @pulled, $card->abbreviation;
    $s--;
    is( $deck->size, $s, "$s still in the deck" );
}

foreach my $a (@pulled) {
    throws_ok sub { $card = $deck->get_card($a)}, 'Cards::Error::NotFound', "$a not found";
}

$deck = Cards::Deck->new();
foreach my $suit (qw(C H D S)) {
    foreach my $number (qw(2 3 4 5 6 7 8 9 10 J Q K A)) {
        my $card_name = $number . $suit;
        my $card      = $deck->get_card($card_name);
        is( $card->abbreviation, $card_name,
            "the $card_name is the right card " );
    }
}
is( $deck->size, 0, "pulled all of the cards" );

throws_ok sub { $card = $deck->get_card($_)}, 'Cards::Error::NoCards', "$_ not found deck is empty"
  for (@pulled);
