package CrabCakes::Hand;

use Moose;
with 'Cards::Role::StackOCards';

my $MIN_HAND_SIZE = 4;    #hand size below which to draw

has minimum_size => (
    is      => 'rw',
    isa     => 'Int',
    default => sub { return $MIN_HAND_SIZE }
);

before add_card => sub {
    my ( $self, $card ) = @_;
    $card->visible_to('player');
};

1;
