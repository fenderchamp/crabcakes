package CrabCakes::Turn;

use Moose;
with 'Cards::Role::JSON';

use constant {
    NEW    => 0,
    DREW   => 1,
    PLAYED => 2,
};

use Moose::Util::TypeConstraints;
enum 'ProgressStepType' => [ ( NEW, DREW, PLAYED ) ];
no Moose::Util::TypeConstraints;

has 'progress' => (
    is      => 'rw',
    isa     => 'ProgressStepType',
    default => sub { NEW }
);

sub step_completed {

    my ($self) = @_;

    if ( $self->progress == NEW ) {
        $self->progress(DREW);
    }
    elsif ( $self->progress == DREW ) {
        $self->progress(PLAYED);
    }
    elsif ( $self->progress == PLAYED ) {
        $self->progress(NEW);
    }
}

sub _json_fields {
    qw( progress );
}
1;
