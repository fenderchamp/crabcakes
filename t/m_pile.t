use strict;
use FindBin;
use lib "$FindBin::Bin/../lib";
use CrabCakes::Model::Pile;
use Test::More 'no_plan';
use Test::Exception;

#buddha — 'Holding onto anger is like drinking poison and expecting the other person to die.'

my $a;
my $pile = CrabCakes::Model::Pile->new();

is( $pile->size, 0, '0 in the deck' );
isa_ok( $pile->cards, 'ARRAY', 'empty ...really I prefere Barney Fife' );

exit;

