package CrabCakes::Game;
use Moose;

use CrabCakes::Deck;
use CrabCakes::Discards;
use CrabCakes::Player;
use CrabCakes::Error::AllPlayersNotReady;
use Session::Token;
use Try::Tiny;

use Moose::Util::TypeConstraints;
enum 'GameSizeType' => [( 2, 3 )];
no Moose::Util::TypeConstraints;

has starting_player => (
    is      => 'rw',
    isa     => 'Str',
    lazy    => 1,
    builder => '_find_starting_player'
);

has 'discards' => (
    is      => 'rw',
    isa     => 'CrabCakes::Discards',
    lazy    => 1,
    default => sub { CrabCakes::Discards->new() }
);

has 'game_size' => (
    is      => 'rw',
    isa     => 'GameSizeType',
    lazy    => 1,
    default => sub { return 2 }
);

has 'deck' => (
    is      => 'rw',
    isa     => 'CrabCakes::Deck',
    lazy    => 1,
    default => sub { CrabCakes::Deck->new() }
);

has 'id' => (
    is      => 'rw',
    isa     => 'Str',
    default => sub {
        return Session::Token->new( length => 24 )->get;
    }
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
        player       => 'get'
    },
);


sub can_start_gameplay {
    my ($self) = @_;
    ( $self->player_count && $self->player_count == $self->ready_player_count );
}
   
sub ready_players { [grep { $_->is_ready } $_[0]->all_players] };  
sub unready_players { [grep { ! $_->is_ready } $_[0]->all_players] };  
sub ready_player_count { @{$_[0]->ready_players} }
sub unready_player_count { @{$_[0]->unready_players} }

sub get_player_by_id { 
    my ($self,$id) = @_;
    return [grep { $id eq $_->id  } $self->all_players]->[0];
}

sub get_players_by_name { 
    my ($self,$name) = @_;
    return [grep { $name eq $_->name  } $self->all_players]; 
}

sub get_player_whos_turn_it_is { 
    my ($self) = @_;
    return [grep { $_->is_turn  } $self->all_players]; 
}


sub BUILD {
    my ($self) = @_;
    my $deck = $self->deck();
    for ( my $card_number = 0 ; $card_number < 4 ; $card_number++ ) {
        for ( my $player_number = 0 ; $player_number < $self->game_size ; $player_number++ ) {
            my $bottom_card = $deck->next_card;
            my $top_card    = $deck->next_card;
            my $card        = $deck->next_card;

            my $crab_cake =
              $self->player($player_number)->get_crab_cake($card_number);

            $crab_cake->add_bottom_card($bottom_card);
            $crab_cake->add_top_card($top_card);
            $self->player($player_number)->add_card($card);
        }
    }
}

sub _players {
    my ( $self ) = (@_);
    my $counter = 0;
    my $players = [];
    while ( $counter < $self->game_size ) {
        push @$players,
          CrabCakes::Player->new(
            player_counter => $counter,
            name => $counter,
          );
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
    return $card->can_play_on_top_of( $self->discards->top_card );
}

sub play_card() {
    my ( $self, %args ) = (@_);
    my $player = $args{player};
    my $card   = $args{card};
}

sub discard_pile() {
    my ( $self, %args ) = (@_);
}

sub player_with_the_most {
    my ($self,$number) = @_;
    my ($player_with_the_most);
    my $largest_count=0;
    my $tie_to_beat=0;
    for my $player ( $self->all_players ) {
       my $count = $player->card_count(in => 'hand', number => $number);
       $tie_to_beat = $count if ( $count == $largest_count );
       if ( $count > $largest_count && $count > $tie_to_beat ) {
         $tie_to_beat = 0;
         $largest_count = $count;
         $player_with_the_most = $player;
       }
    }
    return $player_with_the_most unless ( $tie_to_beat );
    return;
}

sub _find_starting_player {
    my ( $self, %args ) = (@_);

    CrabCakes::Error::AllPlayersNotReady->new( players => $self->unready_players )->throw() unless ( $self->can_start_gameplay );

    my $floor=2;
    my $player_id;
    while ( 1 ) {
        my %held_cards;
        my $last_player;
        for my $player ( $self->all_players ) {
            $player_id = $player->id;
            my $lowest_card_held  = $player->hand->lowest_number( gt => $floor);
            push @{$held_cards{$lowest_card_held}}, $player->id;
        }
       
        unless ( scalar(keys %held_cards) ) {
           last;
        }

        my $lowest = [ sort { $a <=> $b } (keys %held_cards) ]->[0];

        #somebody is holding one card that is lower than anybody elses...woohoo!
        if ( @{$held_cards{$lowest}} == 1 ) {
           $player_id = $held_cards{$lowest}->[0];
           last;
        }
        #somebody is holding more of the lowest cards than andybody else;
        if ( my $one_player = $self->player_with_the_most($lowest) ) {
            $player_id = $one_player->id;
            last;
        }
        $floor=$lowest;
    }
    $self->get_player_by_id($player_id)->is_turn(1);
    return $player_id;

}

1;
