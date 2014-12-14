use strict;
use CrabCakes::Model::Card;

use Test::More 'no_plan';
use Test::Exception;

#buddha — 'Holding onto anger is like drinking poison and expecting the other person to die.'

dies_ok { my $cm = CrabCakes::Model::Card->new() } 'dies new no args';
dies_ok { my $cm = CrabCakes::Model::Card->new( number => 2 ) }
'dies only number no suit';
dies_ok {
    my $cm = CrabCakes::Model::Card->new( number => 19, suit => 'diamonds' )
}
'dies only bad number good suit';
dies_ok { my $cm = CrabCakes::Model::Card->new( number => 2, suit => 'dime' ) }
'dies good number bad suit';

my $cm = CrabCakes::Model::Card->new(
    number       => 2,
    suit         => 'diamonds',
    full_name    => 'pholder',
    abbreviation => 'ph'
);

ok($cm->can('can_play_on_top_of'),'can can_play_on_top_of');
ok($cm->can('is_greater_or_equal_to'),'can is_greater_or_equal_to');
#ok($cm->can('is_special'),'can is_special');

isa_ok( $cm, 'CrabCakes::Model::Card' );
is( $cm->visible_to(), 'nobody', 'visible_to defaulted to nobody' );

my $cm = CrabCakes::Model::Card->new(
    number       => 2,
    suit         => 'hearts',
    full_name    => 'pholder',
    abbreviation => 'ph'
);
isa_ok( $cm, 'CrabCakes::Model::Card' );
my $cm = CrabCakes::Model::Card->new(
    number       => 2,
    suit         => 'spades',
    full_name    => 'pholder',
    abbreviation => 'ph'
);
isa_ok( $cm, 'CrabCakes::Model::Card' );
my $cm = CrabCakes::Model::Card->new(
    number       => 2,
    suit         => 'clubs',
    full_name    => 'pholder',
    abbreviation => 'ph'
);
isa_ok( $cm, 'CrabCakes::Model::Card' );


