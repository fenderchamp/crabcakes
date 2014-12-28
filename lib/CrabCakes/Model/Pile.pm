package CrabCakes::Model::Pile;

use Mouse;
with 'CrabCakes::Model::StackOCards';

has top_card => (
    is  => 'rw',
    isa => 'CrabCakes::Model::Card',
);

sub _new_stack {
    my ($self) = @_;
    my @a;
    return \@a;
}

before add_card => sub {
    my ( $self, $card ) = @_;
    if ( $self->size > 0 ) {
        $self->cards->[ ( $self->size - 1 ) ]->visible_to('nobody')
          if ( defined $self->cards->[ ( $self->size - 1 ) ] );
    }
    $card->visible_to('everybody');
};

after add_card => sub {
    my ( $self, $card ) = @_;
    $self->top_card($card);
};

1;
