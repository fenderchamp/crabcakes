package CrabCakes::Model::Hand;

use Mouse;
with 'CrabCakes::Model::StackOCards';

sub _new_stack {
    my ($self) = @_;
    my @a;
    return \@a;
}

before add_card => sub {
    my ( $self, $card ) = @_;
    unless ($card) {

        $DB::single = 1;
    }
    $card->visible_to('player');
};

1;
