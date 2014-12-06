package CrabCakes::Control::Dealer;

use Mouse;

has game => ( 
   is => 'ro', 
   isa => 'Object', 
   required => 1, 
   default => { 
      sub { return CrabCakes::Model::Game->new() } } 
);

1;
