use strict;
use FindBin;
use lib "$FindBin::Bin/../../lib";
use CrabCakes::Card;

use Test::More 'no_plan';
use Test::Exception;

#buddha — 'Holding onto anger is like drinking poison and expecting the other person to die.'
dies_ok { my $card = CrabCakes::Card->new() } 'dies new no args';
dies_ok { my $card = CrabCakes::Card->new( number => 2 ) } 'dies only number no suit';
dies_ok { my $card = CrabCakes::Card->new( number => 19, suit => 'diamonds' ) } 'dies only bad number good suit';
dies_ok { my $card = CrabCakes::Card->new( number => 2, suit => 'dime' ) } 'dies good number bad suit';

my $card = CrabCakes::Card->new(
    number       => 2,
    suit         => 'diamonds',
    full_name    => 'pholder',
    abbreviation => 'ph'
);

ok( $card->can('can_play_on_top_of'), 'can can_play_on_top_of' );
ok( $card->can('is_greater_or_equal_to'), 'can is_greater_or_equal_to' );
ok( $card->can('is_special'),'can is_special');

isa_ok( $card, 'CrabCakes::Card' );
is( $card->visible_to(), 'nobody', 'visible_to defaulted to nobody' );

my $card = CrabCakes::Card->new(
    number       => 2,
    suit         => 'hearts',
    full_name    => 'pholder',
    abbreviation => 'ph'
);
isa_ok( $card, 'CrabCakes::Card' );
my $card = CrabCakes::Card->new(
    number       => 2,
    suit         => 'spades',
    full_name    => 'pholder',
    abbreviation => 'ph'
);
isa_ok( $card, 'CrabCakes::Card' );
my $card = CrabCakes::Card->new(
    number       => 2,
    suit         => 'clubs',
    full_name    => 'pholder',
    abbreviation => 'ph'
);
isa_ok( $card, 'CrabCakes::Card' );

