package CrabCakes::Model::CrabCakes;

use Mouse;

has cards =>( 
       traits     => ['Array'],
       is         => 'rw',
       isa        => 'ArrayRef',
       handles    => {
           all_cards    => 'elements',
           add_card     => 'push',
           filter_cards => 'grep',
           first_card => 'first',
           last_card  => 'first',
           size       => 'count',
       },
);


sub BUILD {
  my $self=@_;

}

1;

