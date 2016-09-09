package CrabCakes::Deck;

use ClassLoader;
use Moose;
with 'Cards::Role::Deck';

sub _new_card {
    my ( $self, %args ) = @_;
    return CrabCakes::Card->new(%args);
}

1;
