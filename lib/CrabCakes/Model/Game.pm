package CrabCakes::Model::Game;
use Mouse;

use CrabCakes::Model::Deck;
use CrabCakes::Model::Discards;
use CrabCakes::Model::Pile;
use CrabCakes::Model::Player;

use CrabCakes::Model::Player;

use Mouse::Util::TypeConstraints;
enum 'GameSizeType' => ( 2, 3 );
no Mouse::Util::TypeConstraints;

has players_turn => (
    is      => 'rw',
    isa     => 'Int',
    default => sub { return -1; }
);

has starting_player => (
    is      => 'rw',
    isa     => 'Int',
    lazy    => 1,
    builder => '_find_starting_player'
);

has 'discards' => (
    is      => 'rw',
    isa     => 'CrabCakes::Model::Discards',
    lazy    => 1,
    default => sub { CrabCakes::Model::Discards->new() }
);

has 'game_size' => (
    is      => 'rw',
    isa     => 'GameSizeType',
    lazy    => 1,
    default => sub { return 2 }
);

has 'pile' => (
    is      => 'rw',
    isa     => 'CrabCakes::Model::Pile',
    lazy    => 1,
    default => sub { CrabCakes::Model::Pile->new() }
);

has 'players' => (
    traits  => ['Array'],
    is      => 'rw',
    isa     => 'ArrayRef',
    lazy    => 1,
    builder => '_players',
    handles => {
        all_players  => 'elements',
        add_player   => 'push',
        player_count => 'count',
        player       => 'get',
    },
);

sub BUILD {
    my ($self) = @_;
    my $deck = CrabCakes::Model::Deck->new();
    for ( my $hand = 0 ; $hand < 4 ; $hand++ ) {
        for ( my $i = 0 ; $i < $self->game_size ; $i++ ) {
            $self->player($i)->get_crab_cake($hand)
              ->add_bottom_card( $deck->next_card );
            $self->player($i)->get_crab_cake($hand)
              ->add_top_card( $deck->next_card );
            $self->player($i)->take_card( $deck->next_card );
        }
    }
    $self->pile->cards( $deck->cards() );

}

sub _players {
    my ( $self, %args ) = (@_);
    my $counter = 0;
    my $players;
    while ( $counter < $self->game_size ) {
        push @$players,
          CrabCakes::Model::Player->new( player_counter => $counter );
        $counter++;
    }
    return $players;
}

sub draw_card() {
    my ( $self, %args ) = (@_);
    my $player = $args{player};
}

sub can_play_card() {
    my ( $self, %args ) = (@_);
    my $card = $args{card};
    return 1 if ( $card->is_special
        || $card->greater_than( $self->discards->top_card ) );
    return 0;
}

sub play_card() {
    my ( $self, %args ) = (@_);
    my $player = $args{player};
    my $card   = $args{card};
}

sub discard_pile() {
    my ( $self, %args ) = (@_);
}

sub both_players_ready {
    my ($self) = @_;
    for my $player ( $self->all_players ) {
        return 0 unless $player->ready_to_play();
    }
    return 1;
}

sub _find_starting_player {
    my ( $self, %args ) = (@_);
    return -1 unless ( $self->both_players_ready() );
    my $lowest = 15;
    my $count  = 0;
    my $lowest_player;
    for my $player ( $self->all_players ) {
        my ( $lowest_card_held, $count_held ) = $player->lowest();
        if ( $lowest_card_held < $lowest ) {
            $lowest        = $lowest_card_held;
            $count         = $count_held;
            $lowest_player = $player;
        }
        elsif ( $lowest_card_held == $lowest ) {
            if ( $count_held > $count ) {
                $count         = $count_held;
                $lowest_player = $player;
            }
        }
    }
    return $lowest_player->player_counter;
}

1;

