use strict;

use FindBin;
use lib "$FindBin::Bin/../lib";
use CrabCakes::Model::Deck;
use Test::More 'no_plan';
use Test::Exception;

#Aces High

my $a;
my $deck = CrabCakes::Model::Deck->new();
is( $deck->size, 52, '52 in the deck' );

exit;

