package CrabCakes::Control::CardMaker;

use CrabCakes::Model::Card;;
use Mouse;

has short_number  => ( is => 'ro', isa => 'HashRef', required => 1, builder => '_short_number' );
has str_number  => ( is => 'ro', isa => 'HashRef', required => 1, builder => '_long_number' );

has short_suit => ( is => 'ro', isa => 'HashRef', required => 1, builder => '_short_suit' );
has str_suit => ( is => 'ro', isa => 'HashRef', required => 1, builder => '_long_suit' );


sub card {
    my ( $self, %args ) = @_;

    my $full_name = sprintf("%s %s",
       $self->str_number->{$args{number}},
       $self->str_suit->{$args{suit}}
       );

    my $abbreviation = sprintf("%s%s",
       $self->short_number->{$args{number}},
       $self->short_suit->{$args{suit}}
       );
    my $card = CrabCakes::Model::Card->new(
      %args,
      abbreviation => $abbreviation,
      full_name => $full_name
   );

    return $card;
}

sub _long_suit {
    return {
        clubs     => "of Clubs",
        spades   => "of Spades",
        hearts   => "of Hearts",
        diamonds => "of Diamonds"
    };
}
sub _short_suit {
    return {
        clubs     => "C",
        spades   => "S",
        hearts   => "H",
        diamonds => "D"
    };
}


sub _short_number {

    return {
        2   => 2,
        3   => 3,
        4   => 4,
        5   => 5,
        6   => 6,
        7   => 7,
        8   => 8,
        9   => 9,
        10  => 10,
        11  => 'J',
        12  => 'Q',
        13  => 'K',
        14  => 'A'
    };
}



sub _long_number {

    return {
        2   => 'Two',
        3   => 'Three',
        4   => 'Four',
        5   => 'Five',
        6   => 'Six',
        7   => 'Seven',
        8   => 'Eight',
        9   => 'Nine',
        10  => 'Ten',
        11  => 'Jack',
        12  => 'Queen',
        13  => 'King',
        14  => 'Ace',
    };
}

1;

