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
        next_card       => 'pop',
        size            => 'count',
        sort_cards      => 'sort',
    },
);

sub _new_stack {
    my ($self) = @_;
    my @a;
    return \@a;
}

sub get_card {
    my ( $self, $card_to_get ) = @_;

    $card_to_get = uc($card_to_get);

    my ( $card, $position ) = $self->_card_and_position($card_to_get);
    Cards::Error::NotFound->new->throw() unless ( defined($card) );
    $self->_delete_card($position);
    return $card;
}

sub bottom_card {
    my ( $self, $card ) = @_;

    #Cards::Error::NoCards->new()->throw() unless ( $self->size );
    if ($card) {
        $self->add_bottom_card($card);
    }
    else {
        return $self->cards->[0] if ( $self->size );
    }
}

sub add_top_card {
    my ( $self, $card ) = @_;
    $self->top_card($card);
}

sub top_card {
    my ( $self, $card ) = @_;

    #Cards::Error::NoCards->new()->throw() unless ( $self->size );
    if ($card) {
        $_[0]->add_card($card);
    }
    else {
        return $self->cards->[ $self->size - 1 ] if ( $self->size );
    }
}

sub has_card {
    my ( $self, $card_to_get ) = @_;
    my $found = $self->_find_cards($card_to_get);
    return $found;
}

sub _find_cards {
    my ( $self, $card_to_get ) = @_;
    $card_to_get = uc($card_to_get);

    Cards::Error::NotFound->throw("no card not found") unless ($card_to_get);
    if ( $card_to_get =~ /^\d{1,2}$/ ) {
        return grep { $_->number eq $card_to_get } $self->all_cards;
    }
    elsif ( $card_to_get =~ /^([2-9AKQJ0]|10)[HDCS]$/i ) {
        my ( $card, $position ) = $self->_card_and_position($card_to_get);
        return ($card);
    }

}

sub _card_and_position {
    my ( $self, $card_to_get ) = @_;

    Cards::Error::NoCards->new()->throw() unless ( $self->size );

    for ( my $i = 0 ; $i < $self->size ; $i++ ) {
        my $card_found = $self->_get_card($i);
        return ( $card_found, $i )
          if ( $card_found->abbreviation eq $card_to_get );
    }

    Cards::Error::NotFound->throw("${card_to_get} not found");

}

sub face_card_value {
    my ( $self, $card_number ) = @_;
    my $face_card_values = { A => 14, K => 13, Q => 12, J => 11 };
    ( $face_card_values->{$card_number} || $card_number );
}

sub how_many_of {
    my ( $self, $number ) = @_;

    $number = $self->face_card_value($number);
    return scalar( $self->_find_cards($number) );

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
