package Cards::Role::StackOCards;

use Cards::Card;
use Cards::Error::Card::Invalid;
use Cards::Error::NoCards;
use Cards::Error::NotFound;

use Moose::Role;

with 'Cards::Role::JSON';

has 'cards' => (
    traits  => ['Array'],
    is      => 'rw',
    isa     => 'ArrayRef',
    lazy    => 1,
    builder => '_new_stack',
    handles => {
        add_bottom_card => 'unshift',
        add_card        => 'push',
        all_cards       => 'elements',
        _delete_card    => 'delete',
        filter_cards    => 'grep',
        _get_card       => 'get',
        _next_card      => 'pop',
        size            => 'count',
        sort_cards      => 'sort',
    },
);

has '_indexed' => (
    is      => 'rw',
    isa     => 'Bool',
    default => sub { return 0 }
);

has '_by_name' => (
    traits  => ['Hash'],
    is      => 'rw',
    isa     => 'HashRef',
    handles => {
        _get_index    => 'get',
        _delete_index => 'delete'
    }
);

sub BUILD {
}

after BUILD => sub {
    my ($self) = @_;
    $self->build_stack_index() if ( $self->size );
};

before [qw(get_card has_card how_many_of)] => sub {
    my ($self) = @_;
    $self->build_stack_index()
      unless ( $self->_indexed );
};

after [qw(add_card add_bottom_card get_card_by_position)] => sub {
    my ($self) = @_;
    $self->_indexed(0);
};

sub _new_stack {
    my ($self) = @_;
    my @a;
    return \@a;
}

sub _build_by_name {
    my ($self)  = @_;
    my $by_name = {};
    my $count   = 0;
    for my $card ( $self->all_cards ) {
        $by_name->{ $card->abbreviation } = $count;
        push @{ $by_name->{ $card->number } }, $card->suit;
        $count++;
    }
    $self->_indexed(1);
    return $by_name;
}

sub build_stack_index {
    my ($self) = @_;
    Cards::Error::NoCards->new()->throw() unless ( $self->size );
    $self->_by_name( $self->_build_by_name );
}

sub get_card {
    my ( $self, $card_to_get ) = @_;

    $card_to_get = uc($card_to_get);

    my $card_position = $self->_get_index($card_to_get);
    Cards::Error::NotFound->new->throw() unless ( defined($card_position) );

    $self->_delete_index($card_to_get);
    return $self->get_card_by_position($card_position);
}

sub bottom_card {
    my ( $self, $card ) = @_;
    $DB::single = 1;
    if ($card) {
        $self->add_bottom_card($card);
    }
    else {
        return $self->cards->[0] if ( $self->size );
        Cards::Error::NotFound->throw();
    }
}

sub add_top_card {
    my ( $self, $card ) = @_;
    $self->top_card($card);
}

sub top_card {
    my ( $self, $card ) = @_;
    if ($card) {
        $_[0]->add_card($card);
    }
    else {
        return $self->cards->[ $self->size - 1 ] if ( $self->size );
        Cards::Error::NotFound->throw();
    }
}

sub has_card {
    my ( $self, $card_to_get ) = @_;
    Cards::Error::NotFound->throw()
      unless ( defined( $self->_get_index($card_to_get) ) );
    return 1;
}

sub get_card_by_position {
    my ( $self, $array_position ) = @_;
    Cards::Error::NotFound->throw() unless ( defined $array_position );
    my $card = $self->_get_card($array_position);
    if ( defined($card) ) {
        $self->_delete_card($array_position);
    }
    return $card;
}

sub next_card {
    my ($self) = @_;

    #Cards::Error::NoCards->throw() unless ( $self->size );

    my $card = $self->_next_card();
    $self->_delete_index( $card->abbreviation ) if ($card);
    return $card;
}

sub face_card_value {
    my ( $self, $card_number ) = @_;
    my $face_card_values = { A => 14, K => 13, Q => 12, J => 11 };
    ( $face_card_values->{$card_number} || $card_number );
}

sub how_many_of {
    my ( $self, $number ) = @_;
    $number = $self->face_card_value($number);

    #in the by name index we also store the count cards by number
    return @{ $self->_get_index($number) } if ( $self->_get_index($number) );
    return 0;
}

sub lowest_number {
    my ( $self, $modifier, $number ) = @_;
    return $self->lowest_card( $modifier, $number )->number;
}

sub highest_number {
    my ( $self, $modifier, $number ) = @_;
    return $self->highest_card( $modifier, $number )->number;
}

sub lowest_card {
    my ( $self, $modifier, $number ) = @_;
    return $self->_card_sorter( $modifier, $number,
        sub { $_[0]->{number} <=> lc $_[1]->{number} } );
}

sub highest_card {
    my ( $self, $modifier, $number ) = @_;
    return $self->_card_sorter( $modifier, $number,
        sub { $_[1]->{number} <=> lc $_[0]->{number} } );
}

sub _card_sorter {
    my ( $self, $modifier, $number, $sub ) = @_;

    unless ( $number && $modifier ) {
        $number   = 1;
        $modifier = 'gt';
    }
    $number = $self->face_card_value($number);
    my @sorted = $self->sort_cards($sub);
    for (@sorted) {
        if ( $modifier eq 'gt' ) {
            return $_ if ( $_->number > $number );
        }
        elsif ( $modifier eq 'lt' ) {
            return $_ if ( $_->number < $number );
        }
    }
}

sub _json_fields {
    my $self = (@_);
    return qw (cards size);
}

1;
