package CrabCakes::CrabCake;

use CrabCakes::Card;
use Moose;
with 'Cards::Role::StackOCards';

before 'add_bottom_card' => sub {
    my ( $self, $card ) = @_;
    $card->visible_to('nobody');

    #$card;
};

before 'add_top_card' => sub {
    my ( $self, $card ) = @_;
    $card->visible_to('everybody');

    #$card;
};

1;

