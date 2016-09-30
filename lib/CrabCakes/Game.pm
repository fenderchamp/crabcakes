package CrabCakes::Game;

use Moose;
with 'Cards::Role::JSON';

use CrabCakes::Deck;
use CrabCakes::Discards;
use CrabCakes::Player;
use CrabCakes::Error::AllPlayersNotReady;
use CrabCakes::Turn;

use Session::Token;
use Try::Tiny;

use Moose::Util::TypeConstraints;
enum 'GameSizeType' => [ ( 2, 3 ) ];
no Moose::Util::TypeConstraints;

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
    default => sub { 2 }
);

has 'turns_taken' => (
    is      => 'rw',
    isa     => 'Int',
    default => sub { 0 }
);

has 'turn' => (
    is      => 'rw',
    isa     => 'CrabCakes::Turn'
}

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

sub ready_players {
    [ grep { $_->is_ready } $_[0]->all_players ];
}

sub unready_players {
    [ grep { !$_->is_ready } $_[0]->all_players ];
}
sub ready_player_count   { @{ $_[0]->ready_players } }
sub unready_player_count { @{ $_[0]->unready_players } }

sub get_player_by_id {
    my ( $self, $id ) = @_;
    return [ grep { $id eq $_->id } $self->all_players ]->[0];
}

sub get_players_by_name {
    my ( $self, $name ) = @_;
    return [ grep { $name eq $_->name } $self->all_players ];
}

sub get_player_whos_turn_it_is {
    my ($self) = @_;
    return [ grep { $_->is_turn } $self->all_players ];
}

sub get_player_by_counter {
    my ($self,$counter) = @_;
    return [ grep { $_->player_counter == $counter } $self->all_players ];
}

sub BUILD {
    my ($self) = @_;
    $self->deal
      if ( $self->deck->size == 52 )
      ;    #if this game was created in place we don't need to deal again
}

sub deal {

    my ($self) = @_;
    my $deck = $self->deck();
    for ( my $card_number = 0 ; $card_number < 4 ; $card_number++ ) {
        for (
            my $player_number = 0 ;
            $player_number < $self->game_size ;
            $player_number++
          )
        {
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
    my ($self)  = (@_);
    my $counter = 0;
    my $players = [];
    while ( $counter < $self->game_size ) {
        push @$players,
          CrabCakes::Player->new(
            player_counter => $counter,
            name           => $counter,
          );
        $counter++;
    }
    return $players;
}


sub draw_card() {
    my ( $self, %args ) = (@_);
    my $player_id = $args{id};
    my $player = $self->get_player_by_id($player_id); 
}

sub can_play_card() {
    my ( $self, %args ) = (@_);
    my $card = $args{card};
    return $card->can_play_on_top_of( $self->discards->top_card );
}

sub take_turn() {
    my ( $self, %args ) = (@_);

    my $player_id = $args{id};

    my $player = $self->get_player_whos_turn_it_is();
    unless ( $player->id eq $id ) {
      die 'invalid player for turn';
    }

    my $turn=>self->turn();
    unless ( $turn ) {
      $turn = CrabCakes::Turn->new();
      $self->turn(turn);
    }

    if ( $turn->progress == $turn->INIT ) {
       $player->perhaps_flip_crabcakes();
       $player->draw_card();
       unless ( $player->has_card_to_play ) {
         $self->give_player_all_the_discards();
       }
    } elsif ( $turn->progress == $turn->DREW ) {
       $player->play_card($card);
       if ( $card->is_special ) {
          return;
       }
    } elsif ( $turn->progress == $turn->PLAYED ) {
       $player->perhaps_flip_crabcakes();
       $self->switch_player_turns;
       $turn->progress($turn->INIT);
    }
    $turn->step_completed();

}

sub play_card() {
    my ( $self, %args ) = (@_);

    my $player_id = $args{id};
    my $card = $args{card};

    my $player = $self->get_player_by_id($player_id); 
    if ( $player->has_card_in_hand($card) && $self->can_play_card ) {
        $self->discards->add_card($player->hand->get_card);
    }
};
    
sub discard_pile() {
    my ( $self, %args ) = (@_);

}

sub player_with_the_most {
    my ( $self, $number ) = @_;
    my ($player_with_the_most);
    my $largest_count = 0;
    my $tie_to_beat   = 0;
    for my $player ( $self->all_players ) {
        my $count = $player->card_count( in => 'hand', number => $number );
        $tie_to_beat = $count if ( $count == $largest_count );
        if ( $count > $largest_count && $count > $tie_to_beat ) {
            $tie_to_beat          = 0;
            $largest_count        = $count;
            $player_with_the_most = $player;
        }
    }
    return $player_with_the_most unless ($tie_to_beat);
    return;
}

# the player that starts is the player with the lowest cards that aren't special cards (2,7,10)
# in case of a tie the player with the most of the lowest card starts
# in case of stalemate its usually the player the closest to the dealer
# but there is no dealer here so We'll use player 1 always and if the front end wants to alternate
# between games it will have to worry about it.  We are stateless (hopefully)

sub starting_player {
    my ($self) = @_;

    return "PlayersNotReady" unless $self->can_start_gameplay;

    my $player_id =
      $self->players->[0]->id;    #default id incase there isn't anyone else
    my $floor = 2;                #two is a special card so don't count those.
    while (1) {
        my %held_cards;
        my $last_player;
        for my $player ( $self->all_players ) {
            $player_id = $player->id;
            my $number;
            while (1) {
                $number = $floor unless ($number);
                my $lowest_card_held =
                  $player->hand->lowest_card( gt => $number );
                unless ($lowest_card_held) {
                    undef($number);
                    last;
                }
                $number = $lowest_card_held->number;
                last unless ( $lowest_card_held->is_special );
            }
            push @{ $held_cards{$number} }, $player->id if ($number);
        }

        unless ( scalar( keys %held_cards ) ) {
            last;
        }

        my $lowest = [ sort { $a <=> $b } ( keys %held_cards ) ]->[0];

        #somebody is holding one card that is lower than anybody elses...woohoo!
        if ( @{ $held_cards{$lowest} } == 1 ) {
            $player_id = $held_cards{$lowest}->[0];
            last;
        }

        #somebody is holding more of the lowest cards than andybody else;
        if ( my $one_player = $self->player_with_the_most($lowest) ) {
            $player_id = $one_player->id;
            last;
        }
        $floor = $lowest;
    }
    $self->get_player_by_id($player_id)->is_turn(1);
    return $player_id;

}

#sub all_cards {
#    my ( $self ) = @_;
#
#    my $all_cards; 
#    for $card in ( $deck->cards ) { 
#
#        push @all_cards, CrabCakes::CardForMessage->new( 
#           $card, 
#           possessed_by=>'deck'
#        );
#
#    }
#    #my $top_card=$self->discards->top_card();
#    #$i, $card in ( $discard->cards ) { 
#    #    push @all_cards, $card;
#    #}
#    #for my $player, $self->players
#   
#}

#sub { return qw (starting_player discards game_size deck id players ready_players all_cards); }

sub _json_fields { qw (starting_player discards game_size deck id players ready_players ); }

1;

