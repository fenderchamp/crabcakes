package CrabCakes::Model::Card;

use Mouse;

use Mouse::Util::TypeConstraints;

enum 'Suit' => qw(clubs spades hearts diamonds);
enum 'VisibilityTrait' => qw(player nobody everybody);
enum 'CardNumber' => (2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14);

no Mouse::Util::TypeConstraints;

has 'suit' => (
    is      => 'rw',
    isa      => 'Suit',
    required => 1
);

has 'number' => (
    is      => 'rw',
    isa      => 'CardNumber',
    required => 1
);

has 'visible_to' => (
    is      => 'rw',
    isa      => 'VisibilityTrait',
    required => 1,
    default => sub { return 'nobody' }
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

1;

