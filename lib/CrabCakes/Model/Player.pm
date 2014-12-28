package CrabCakes::Model::Player;
use CrabCakes::Model::Hand;
use CrabCakes::Model::CrabCake;
use Mouse;

use Mouse::Util::TypeConstraints;
enum 'PlayerCounterType' => ( 0, 1, 2 );
no Mouse::Util::TypeConstraints;

has '_crab_cakes_count' => (
    is      => 'rw',
    isa     => 'Int',
    lazy    => 1,
    default => sub { return 4 }
);

has crab_cakes => (
    traits  => ['Array'],
    is      => 'rw',
    isa     => 'ArrayRef',
    lazy    => 1,
    builder => '_crab_cakes',
    handles => {
        crab_cake        => 'get',
        add_crab_cake    => 'push',
        get_crab_cake    => 'get',
        crab_cakes_count => 'count'
    },
);

has hand => (
    is      => 'rw',
    isa     => 'CrabCakes::Model::Hand',
    lazy    => 1,
    default => sub { return CrabCakes::Model::Hand->new() }
);

has player_counter => (
    is       => 'ro',
    isa      => 'PlayerCounterType',
    required => 1
);

has 'ready' => (
    is      => 'rw',
    isa     => 'Bool',
    lazy    => 1,
    default => sub { return 0 }
);

has 'game_reference' => (
    is  => 'rw',
    isa => 'Object'
);

sub _crab_cakes {
    my ($self) = @_;
    my $ccs;
    my $i = 0;
    while ( $i++ < $self->_crab_cakes_count() ) {
        push @$ccs, CrabCakes::Model::CrabCake->new();
    }
    return $ccs;

}

sub hand_size {
    my ($self) = @_;
    return $self->hand->size;
}

sub has_card_in_hand {
    my ( $self, $card_name ) = @_;
    return $self->hand->has_card($card_name);
}

sub card_to_crabcake {
    my ( $self, $card_name, $crab_cake_number ) = @_;
    my $card_from_hand = $self->hand->get_card($card_name);
    my $top_card       = $self->get_crab_cake($crab_cake_number)->top_card();
    $self->get_crab_cake($crab_cake_number)->top_card($card_from_hand);
    $self->add_card($top_card);
}

sub add_card {
    my ( $self, $card ) = @_;
    $self->hand->add_card($card);
}

1;
