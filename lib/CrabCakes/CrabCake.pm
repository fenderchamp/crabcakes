package CrabCakes::CrabCake;

use CrabCakes::Card;

use Moose;

has top_card => (
    is  => 'rw',
    isa => 'CrabCakes::Card',
);
has bottom_card => (
    is  => 'rw',
    isa => 'CrabCakes::Card',
);

sub add_top_card {
    my ( $self, $card ) = @_;
    $card->visible_to('everybody');
    $self->top_card($card);
}

sub add_bottom_card {
    my ( $self, $card ) = @_;
    $card->visible_to('nobody');
    $self->bottom_card($card);
}

1;

