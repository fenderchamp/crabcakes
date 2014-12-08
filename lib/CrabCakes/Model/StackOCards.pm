package CrabCakes::Model::StackOCards;
use Mouse::Role;

requires qw(_new_stack);

has 'cards' => (
       traits     => ['Array'],
       is         => 'rw',
       isa        => 'ArrayRef',
       lazy       => 1,
       builder    => '_new_stack',
       handles    => {
           all_cards    => 'elements',
           add_card     => 'push',
           filter_cards => 'grep',
           size       => 'count',
       },
);

1;
