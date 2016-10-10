package CrabCakes::Card;

use Moose;

extends 'Cards::Card';

sub can_play_on_top_of {
    my ( $self, $card ) = @_;
    return 1 unless ( $card && $card->number );
    return 1 if ( $self->is_special );
    unless ( $card->number == 7 ) {
        return 1 if $self->greater($card);
    }
    else {
        return 1 if $card->greater($self);
    }
}

sub is_greater_or_equal_to {
    my ( $self, $card ) = @_;
    return 1 if ( $self->number >= $card->number );
}

sub plays_again {
    my ($self) = @_;
    my $plays_again = {
        2  => 1,
        10 => 1
    };
    return 1 if ( $plays_again->{ $self->number } );
}

sub is_special {
    my ($self) = @_;
    my $specials = {
        2  => 1,
        7  => 1,
        10 => 1
    };
    return 1 if ( $specials->{ $self->number } );
}

1;
