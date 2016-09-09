package CrabCakes::Discards;

use Moose;
with 'Cards::Role::StackOCards';

sub _new_stack {
    my ($self) = @_;
    my @a;
    return \@a;
}

before add_card => sub {
    my ( $self, $card ) = @_;
    $card->visible_to('nobody');
};

1;
