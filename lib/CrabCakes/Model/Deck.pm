package CrabCakes::Model::Deck;

use Mouse;
with 'CrabCakes::Model::StackOCards';
use CrabCakes::Control::CardMaker;

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

sub BUILD {
    my ($self) = @_;
}

sub _new_stack {
    my ($self) = @_;
    my @deck = $self->_shuffle_deck();
    return \@deck;
}

sub _build_sorted_deck {

    my ($self) = @_;

    my $deck = [];

    my $cardMaker = CrabCakes::Control::CardMaker->new;
    foreach my $suit (qw(clubs diamonds hearts spades)) {
        for ( my $number = 2 ; $number <= 14 ; $number++ ) {
            push @$deck, $cardMaker->card( number => $number, suit => $suit );
        }
    }
    return $deck;

}

before add_card => sub {
    my ( $self, $card ) = @_;
    $card->visible_to('nobody');
};

1;
