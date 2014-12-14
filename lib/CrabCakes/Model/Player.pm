package CrabCakes::Model::Player;
use CrabCakes::Model::Hand;
use CrabCakes::Model::CrabCake;
use Mouse;

use Mouse::Util::TypeConstraints;
enum 'PlayerCounterType'      => ( 0, 1, 2 );
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
    default => sub { return 0}
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

sub card_to_crabcake {
    my ( $self,$card,$crabcake ) = @_;
}

sub take_card {
    my ( $self, $card ) = @_;
    $card->visible_to('player');
    $self->hand->add_card($card);
}

1;
