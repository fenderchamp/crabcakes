package CrabCakes::Model::Hand;

use Mouse;
with 'CrabCakes::Model::StackOCards';

sub _new_stack {
   my ($self)=@_;
   my @a;
   return \@a;
}

1;