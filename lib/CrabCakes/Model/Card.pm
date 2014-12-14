package CrabCakes::Model::Card;

use Mouse;

use Mouse::Util::TypeConstraints;

enum 'Suit'            => qw(clubs spades hearts diamonds);
enum 'VisibilityTrait' => qw(player nobody everybody);
enum 'CardNumber'      => ( 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 );

no Mouse::Util::TypeConstraints;

has 'suit' => (
    is       => 'rw',
    isa      => 'Suit',
    required => 1
);

has 'number' => (
    is       => 'rw',
    isa      => 'CardNumber',
    required => 1
);

has 'visible_to' => (
    is       => 'rw',
    isa      => 'VisibilityTrait',
    required => 1,
    default  => sub { return 'nobody' }
);

has 'full_name' => (
    is       => 'rw',
    isa      => 'Str',
    required => 1
);

#non ironically
has 'abbreviation' => (
    is       => 'rw',
    isa      => 'Str',
    required => 1
);

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

sub is_special {
    my ($self) = @_;
    my $specials = {
        2  => 1,
        7  => 2,
        10 => 1
    };
    return 1 if ( $specials->{ $self->number } );
}

1;

