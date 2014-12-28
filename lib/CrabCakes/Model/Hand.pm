package CrabCakes::Model::Hand;

use Mouse;
with 'CrabCakes::Model::StackOCards';

my $MIN_HAND_SIZE = 4;    #hand size below which to draw

has minimum_size => (
    is      => 'rw',
    isa     => 'Int',
    default => sub { return $MIN_HAND_SIZE }
);

sub _new_stack {
    my ($self) = @_;
    my @a;
    return \@a;
}

before add_card => sub {
    my ( $self, $card ) = @_;
    $card->visible_to('player');
};

1;
