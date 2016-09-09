package Cards::Role::Deck;

use ClassLoader;
use Moose::Role;

with 'Cards::Role::StackOCards';

requires '_new_card';

has '_sorted_cards' => (
    traits  => ['Array'],
    is      => 'rw',
    isa     => 'ArrayRef',
    lazy    => 1,
    builder => '_build_sorted_deck',
    handles => {
        _shuffle_deck => 'shuffle'
    },
);

sub _new_stack {
    my ($self) = @_;
    my @deck = $self->_shuffle_deck();
    return \@deck;
}

sub _new_card {
    my ( $self, %args ) = @_;
    return Cards::Card->new(%args);
}

sub _build_sorted_deck {

    my ($self) = @_;

    my $deck = [];
    foreach my $suit (qw(clubs diamonds hearts spades)) {
        for ( my $number = 2 ; $number <= 14 ; $number++ ) {
            push @$deck, $self->_new_card( number => $number, suit => $suit );
        }
    }
    return $deck;

}

1;
