package CrabCakes::Error::CardNotPlayable;

use Moose;
extends 'Cards::Error';

has 'card_to_play' => (
    isa      => 'CrabCakes::Card',
    is       => 'ro',
    required => 1
);

has 'card_on_discards' => (
    isa      => 'CrabCakes::Card',
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
    return $_[0]->card_to_play->long_name
      . "cannot be played on top of"
      . $_[0]->card_on_discards->long_name;
}

1;
