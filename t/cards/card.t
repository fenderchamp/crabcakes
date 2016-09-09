use strict;
use FindBin;
use lib "$FindBin::Bin/../../lib";
use Cards::Card;

use Test::More 'no_plan';
use Test::Exception;

#buddha — 'Holding onto anger is like drinking poison and expecting the other person to die.'
dies_ok { my $card = Cards::Card->new() } 'dies new no args';
dies_ok { my $card = Cards::Card->new( number => 2 ) } 'dies only number no suit';
dies_ok { my $card = Cards::Card->new( number => 19, suit => 'diamonds' ) } 'dies only bad number good suit';
dies_ok { my $card = Cards::Card->new( number => 2, suit => 'dime' ) } 'dies good number bad suit';

my $card = Cards::Card->new(
    number       => 2,
    suit         => 'diamonds',
    full_name    => 'pholder',
    abbreviation => 'ph'
);

isa_ok( $card, 'Cards::Card' );
is( $card->visible_to(), 'nobody', 'visible_to defaulted to nobody' );

my $card = Cards::Card->new(
    number       => 2,
    suit         => 'hearts',
    full_name    => 'pholder',
    abbreviation => 'ph'
);
isa_ok( $card, 'Cards::Card' );
my $card = Cards::Card->new(
    number       => 2,
    suit         => 'spades',
    full_name    => 'pholder',
    abbreviation => 'ph'
);
isa_ok( $card, 'Cards::Card' );
my $card = Cards::Card->new(
    number       => 2,
    suit         => 'clubs',
    full_name    => 'pholder',
    abbreviation => 'ph'
);
isa_ok( $card, 'Cards::Card' );

