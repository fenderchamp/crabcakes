package CrabCakes::Model::Pile;

use Mouse;
with 'CrabCakes::Model::StackOCards';

sub _new_stack {
    my ($self) = @_;
    my @a;
    return \@a;
};

before add_card=>sub{
    my ($self,$card) = @_;
    $card->visible_to('nobody');
};

1;
