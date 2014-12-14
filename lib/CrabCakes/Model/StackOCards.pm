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
        get_card     => 'get',
        size         => 'count',
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
    my ($self) = @_;
    $self->index_stack();
}

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

sub index_stack {
    my ($self) = @_;
    $self->_by_name($self->_build_by_name);
    $self->_indexed(1);
}

sub get_card_by_name {
    my ($self,$card_to_get) = @_;
    unless ( $self->_indexed ) {
      $self->index_stack();
    }
    return $self->get_card($self->_get_index($card_to_get));
}
sub add_card {
    my ($self,$card) = @_;
    $self->add_card();
    $self->_indexed(0);
}
sub next_card {
   my ($self)=@_; 
   my $card=$self->_next_card();
   $self->_delete_index($card->abbreviation);
   return $card;
}

1;
