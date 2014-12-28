package CrabCakes::Model::StackOCards;
use Mouse::Role;

requires qw(_new_stack);

has 'cards' => (
    traits  => ['Array'],
    is      => 'rw',
    isa     => 'ArrayRef',
    lazy    => 1,
    builder => '_new_stack',
    handles => {
        all_cards    => 'elements',
        _add_card     => 'push',
        _next_card    => 'pop',
        filter_cards => 'grep',
        _get_card     => 'get',
        _delete_card => 'delete',
        size         => 'count'
    },
);

has '_indexed' => (
   is =>'rw',
   isa =>'Bool',
   default => sub {return 0}
);

has '_by_name'=>(
    traits  => ['Hash'],
    is      => 'rw',
    isa     => 'HashRef',
    handles => {
       _get_index => 'get',
       _delete_index => 'delete'
    }
); 

sub BUILD {
}

after BUILD => sub { 
    my ($self) = @_;
    $self->build_stack_index();
};

sub add_card{
    my ($self,$card) = @_;
    $self->_add_card($card);
    $self->_indexed(0);
};

sub _build_by_name {
    my ($self) = @_;
    my $by_name={};
    my $count=0;
    for my $card ($self->all_cards ) {
      $by_name->{$card->abbreviation}=$count; 
      $count++;
    }
    $self->_indexed(1);
    return $by_name;
}

sub build_stack_index {
    my ($self) = @_;
    $self->_by_name($self->_build_by_name);
    $self->_indexed(1);
}

sub get_card {
    my ($self,$card_to_get) = @_;
    $card_to_get=uc($card_to_get);

    unless ( $self->_indexed ) {
      $self->build_stack_index();
    }
    my $card_position=$self->_get_index($card_to_get);
    return ( undef ) unless ( defined ($card_position) );

    $self->_delete_index($card_to_get);
    return $self->get_card_by_position($card_position);
}

sub has_card {
    my ($self,$card_to_get) = @_;
    unless ( $self->_indexed ) {
      $self->build_stack_index();
    }
    return 0  unless ( defined($self->_get_index($card_to_get)) );
    return 1;
}

sub get_card_by_position {
    my ($self,$array_position) = @_;
    return undef unless ( defined $array_position );
    my $card = $self->_get_card($array_position);
    if ( defined($card)) { 
       $self->_delete_card($array_position);
    }
    $self->_indexed(0);
    return $card;
}

sub next_card {
   my ($self)=@_; 
   my $card=$self->_next_card();
   $self->_delete_index($card->abbreviation);
   return $card;
}

1;
