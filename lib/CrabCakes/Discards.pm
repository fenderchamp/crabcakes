package CrabCakes::Discards;

use Moose;
with 'Cards::Role::StackOCards';

before 'add_card' => sub {
    my ( $self, $card ) = @_;
    $card->visible_to('everybody');
    $self->top_card->visible_to('nobody') if ( $self->size );
};

1;
