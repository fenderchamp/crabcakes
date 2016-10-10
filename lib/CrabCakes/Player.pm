package CrabCakes::Player;

use Moose;
with 'Cards::Role::JSON';

use CrabCakes::Hand;
use CrabCakes::CrabCake;
use Session::Token;

has hand => (
    is      => 'rw',
    isa     => 'CrabCakes::Hand',
    lazy    => 1,
    default => sub { return CrabCakes::Hand->new() }
);

has is_turn  => ( is => 'rw', isa => 'Bool', default => sub { return 0 } );
has is_ready => ( is => 'rw', isa => 'Bool', default => sub { return 0 } );

has 'id' => (
    is      => 'ro',
    isa     => 'Str',
    default => sub { return Session::Token->new( length => 24 )->get; }
);

has name           => ( is => 'ro', isa => 'Str', required => 0, );
has player_counter => ( is => 'ro', isa => 'Int', required => 0 );
has turns_taken => ( is => 'rw', isa => 'Int', default => sub { return 0 } );

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

has '_crab_cakes_count' => (
    is      => 'rw',
    isa     => 'Int',
    lazy    => 1,
    default => sub { return 4 }
);

#crab_cakes builder
sub _crab_cakes {
    my ($self) = @_;
    my $ccs;
    my $i = 0;
    while ( $i++ < $self->_crab_cakes_count() ) {
        push @$ccs, CrabCakes::CrabCake->new();
    }
    return $ccs;
}

#methods

sub add_card {
    my ( $self, $card ) = @_;
    $self->hand->add_card($card);
}

sub get_card {
    my ( $self, $card ) = @_;
    my $hand = $self->hand;

    if ( $hand->size ) {
        return $hand->get_card($card);
    }
    else {
        for my $crabcake ( $self->crabcakes ) {
            my $card = $crabcake->see_card($card);
            if ( $card->is_visible ) {
                return $crabcake->get_card( $card->abbreviation );
            }
        }
    }
}

sub hand_size {
    my ($self) = @_;
    return $self->hand->size;
}

sub has_card_in_hand {
    my ( $self, $card_name ) = @_;
    return $self->hand->has_card($card_name);
}

sub draw_new_card {
    my ( $self, $deck ) = @_;
    return unless ( $self->hand_size < $self->hand->minimum_size );
    $self->add_card( $deck->next_card() );
}

sub card_to_crabcake {
    my ( $self, $card_name, $crab_cake_number ) = @_;
    my $card_from_hand = $self->hand->get_card($card_name);
    my $top_card       = $self->get_crab_cake($crab_cake_number)->top_card();
    $self->get_crab_cake($crab_cake_number)->top_card($card_from_hand);
    $self->add_card($top_card);
}

sub card_count {
    my ( $self, %args ) = @_;
    my $number = $args{number};
    my $in     = $args{in};
    my $count;
    if ( $in eq 'hand' ) {
        $count += $self->hand->how_many_of($number);
    }
    else {
        #TODO count the crabcakes up
        #TODO count everything up
        #TODO count the stars in the midnight sky
        #TODO love thy enemas
        #TODO love everyone in the world equally
        #TODO rock like iggy and the stooges
        #TODO tonight hold my self tight
    }
    return $count;
}

sub perhaps_flip_crabcakes {
    my ($self) = @_;
    return if $self->hand->size;
    my $visible;
    my $cards = 0;
    for my $crabcake ( $self->crabcakes ) {
        for my $card ( $crabcake->all_cards ) {
            $cards++;
            $visible++ if ( $card->visible_to eq 'everybody' );
        }
    }
    return unless ( $cards && !$visible );
    for my $crabcake ( $self->crabcakes ) {
        for my $card ( $crabcake->all_cards ) {
            $card->visible_to('everybody');
        }
    }
    return 1;
}

sub playable_cards {
    my ( $self, %args ) = @_;
    my $discard  = $args{card};
    my $playable = [];
    for my $card ( $self->hand->all_cards ) {
        push @{$playable}, $card if $card->can_play_on_top_of($discard);
    }
    return $playable if $self->hand->size;
    for my $crabcake ( $self->crabcakes ) {
        for my $card ( $crabcake->all_cards ) {
            push @{$playable}, $card
              if ( $card->visible_to eq 'everybody'
                && $card->can_play_on_top_of($discard) );
        }
    }
    return $playable;
}

sub _json_fields {
    return
      qw( hand is_turn is_ready id name player_counter turns_taken crab_cakes hand_size );
}

1;
