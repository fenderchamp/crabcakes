package 'CrabCakes::Turn';

use Moose;
use constant  {
  INIT => 0,
  DREW  => 1,
  PLAYED  => 2,
};

use Moose::Util::TypeConstraints;

enum 'ProgressStepType' => [ ( INIT, DREW, PLAYED ) ];
no Moose::Util::TypeConstraints;

has 'progress' => (
    is => 'rw';  
    isa => 'ProgressStepType';  
    default => sub { INIT };
}

sub step_completed {
    my ( $self ) = @_; 
    $self->progress( $self->progress + 1 );
}

1;
