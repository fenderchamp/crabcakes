package Cards::Error::NoCards;

#
use Moose;
extends 'Cards::Error';

has 'message' => (
    isa      => 'Str',
    is       => 'ro',
    required => 0,
    lazy     => 1,
    builder  => '_message'
);

sub _message {
    my ($self) = @_;
    'No Cards';
}

1;
