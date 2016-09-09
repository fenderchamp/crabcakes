package CrabCakes::Discards;

use Moose;
with 'Cards::Role::StackOCards';

before add_card => sub {
    my ( $self, $card ) = @_;
    $card->visible_to('nobody');
};

1;
