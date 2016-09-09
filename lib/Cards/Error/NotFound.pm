package Cards::Error::NotFound;

use Moose;
extends 'Cards::Error';

has 'message' => (
  isa => 'Str',
  is => 'ro',
  required => 0,
  lazy => 1,
  builder => '_message'
);

sub _message {
  my ($self)=@_;
  'Card Not Found';
}

1;
