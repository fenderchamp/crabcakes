use strict;
use CrabCakes::Model::Deck;
use Test::More 'no_plan';
use Test::Exception;

#buddha — 'Holding onto anger is like drinking poison and expecting the other person to die.'

my $a;
my $deck = CrabCakes::Model::Deck->new();
isa_ok($deck,'CrabCakes::Model::Deck', 'deck object created');
is( $deck->size, 52, '52 in the deck' );

foreach my $number (qw(2 3 4 5 6 8 9 10 J Q K A)) {
   foreach my $suit (qw(H D C S)) {
       my $str=$number.$suit; 
       ok($deck->has_card($str),"$str found");

   }
}
my $card=$deck->get_card_by_name('QH');
isa_ok($card,'CrabCakes::Model::Card', 'deck object found');
is($card->abbreviation,'QH','the QH is found');
ok(! $deck->has_card('QH'),"QH not has");
is( $deck->size, 51, '51 in the deck' );
$card=$deck->get_card_by_name('QH');
is($card,undef,'the QH is not found now');
is( $deck->size, 51, '51 still in the deck' );

my $card=$deck->next_card();
isa_ok($card,'CrabCakes::Model::Card', 'object found is a card');
is( $deck->size, 50, '50 still in the deck' );
my $s=$deck->size;

my @pulled;
foreach (1..5) {
   my $card=$deck->next_card();
   push @pulled, $card->abbreviation;
   $s-=1;
   is( $deck->size, $s, "$s still in the deck" );
}

foreach my $a (@pulled) {
$DB::single=1;
   my $card=$deck->get_card_by_name($a);
   is($card,undef,'card is not in deck anymore');
}







exit;

