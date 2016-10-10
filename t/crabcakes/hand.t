use strict;
use FindBin;
use lib "$FindBin::Bin/../../lib";
use lib "$FindBin::Bin/../../t/lib";

use Test::Cards::JSON qw(copy_by_json);

use CrabCakes::Hand;
use Test::More;
use Test::Exception;

#buddha — 'Holding onto anger is like drinking poison and expecting the other person to die.'

my $hand = CrabCakes::Hand->new();

is( $hand->size, 0, '0 in the deck' );
isa_ok( $hand->cards, 'ARRAY', 'empty ...really I prefere Barney Fife' );

my $new = copy_by_json($hand);

done_testing();

exit;

