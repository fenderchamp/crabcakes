package CrabCakes::Model::Player;
use CrabCakes::Model::Hand;
use CrabCakes::Model::CrabCake;
use Mouse;

has 'crab_cakes_count' => (
       is         => 'rw',
       isa        => 'Int',
       lazy       => 1,
       default => sub { return 4 }
);

has crab_cakes => (
       traits     => ['Array'],
       is         => 'rw',
       isa        => 'ArrayRef',
       lazy       => 1,
       builder    => '_crab_cakes',
       handles    => {
           crab_cake      => 'get',
           add_crab_cake  => 'push'
       },
);

has hand =>  (
   is => 'rw',
   isa => 'CrabCakes::Model::Hand',
   lazy => 1,
   default => sub { return CrabCakes::Model::Hand->new() }
);

sub _crab_cakes {
  my ($self)=@_;
   my $ccs;
   my $i=0;
   while ( $i++ < $self->crab_cakes_count() ) {
      push @$ccs,CrabCakes::Model::CrabCake->new();
   }
   return $ccs;

}


1;
