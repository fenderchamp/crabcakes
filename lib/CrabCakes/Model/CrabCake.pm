package CrabCakes::Model::CrabCake;

use Mouse;

has top_card => (
    is  => 'rw',
    isa => 'CrabCakes::Model::Card',
);
has bottom_card => (
    is  => 'rw',
    isa => 'CrabCakes::Model::Card',
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

