package Cards::Card;

use Moose;
with 'Cards::Role::JSON';

use Moose::Util::TypeConstraints;

enum 'Suit'            => [qw(clubs spades hearts diamonds)];
enum 'VisibilityTrait' => [qw(player nobody everybody)];
enum 'CardNumber'      => [ ( 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 ) ];

no Moose::Util::TypeConstraints;

has 'suit' => (
    is       => 'ro',
    isa      => 'Suit',
    required => 1
);

has 'number' => (
    is       => 'ro',
    isa      => 'CardNumber',
    required => 1
);

has 'visible_to' => (
    is       => 'rw',
    isa      => 'VisibilityTrait',
    required => 0,
    lazy     => 1,
    default  => sub { return 'nobody' }
);

sub full_name {
    my ($self) = @_;

    my $suit = {
        clubs    => "of Clubs",
        spades   => "of Spades",
        hearts   => "of Hearts",
        diamonds => "of Diamonds",
    };

    my $name = {
        2  => 'Two',
        3  => 'Three',
        4  => 'Four',
        5  => 'Five',
        6  => 'Six',
        7  => 'Seven',
        8  => 'Eight',
        9  => 'Nine',
        10 => 'Ten',
        11 => 'Jack',
        12 => 'Queen',
        13 => 'King',
        14 => 'Ace',
    };
    return
      sprintf( "%s %s", $name->{ $self->{number} }, $suit->{ $self->{suit} } );
}

sub abbreviation {
    my ($self) = @_;

    my $suit = { clubs => "C", spades => "S", hearts => "H", diamonds => "D" };

    my $name = {
        2  => 2,
        3  => 3,
        4  => 4,
        5  => 5,
        6  => 6,
        7  => 7,
        8  => 8,
        9  => 9,
        10 => 10,
        11 => 'J',
        12 => 'Q',
        13 => 'K',
        14 => 'A'
    };
    return
      sprintf( "%s%s", $name->{ $self->{number} }, $suit->{ $self->{suit} } );
}

sub _json_fields {
    return qw(suit number visible_to full_name abbreviation);
}

1;
