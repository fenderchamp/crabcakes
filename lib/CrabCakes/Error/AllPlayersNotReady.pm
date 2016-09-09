package CrabCakes::Error::AllPlayersNotReady;

use Moose;
extends 'Cards::Error';

has 'players' => (
    isa      => 'ArrayRef',
    is       => 'ro',
    required => 1
);

has 'message' => (
    isa      => 'Str',
    is       => 'ro',
    required => 0,
    lazy     => 1,
    builder  => '_message'
);

sub _message {
    my ($self) = @_;
    'all players must be ready, not ready ' . join ',', map $_->name,
      @{ $self->players };
}

1;
