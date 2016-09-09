package CrabCakes::CrabCake;

use CrabCakes::Card;
use Moose;
with 'Cards::Role::StackOCards';

before qw(add_bottom_card) => sub {
    my ( $self, $card ) = @_;
    $card->visible_to('nobody');

    #$card;
};

before qw(add_top_card) => sub {
    my ( $self, $card ) = @_;
    $card->visible_to('everybody');

    #$card;
};

1;

