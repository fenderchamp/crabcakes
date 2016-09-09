package Cards::Role::JSON;

use JSON::XS;
use Moose::Role;
use ClassLoader;

requires '_json_fields';

has json_xs => (
    is      => 'ro',
    isa     => 'JSON::XS',
    lazy    => 1,
    default => sub { JSON::XS->new->allow_nonref }
);

around 'BUILDARGS' => sub {
    my ( $method, $class, %args ) = @_;
    if ( $args{json} ) {
        %args = $class->new_from_json(%args);
    }
    $class->$method(%args);

};

sub to_json {

    my ( $self, $raw ) = @_;
    my $data = { ref => ref($self) };

    for my $attribute ( sort ( $self->_json_fields ) ) {
        my $value = $self->$attribute();
        if ( ref $value eq 'ARRAY' ) {

            for (@$value) {
                push @{ $data->{$attribute} }, $_->to_json('RAW')
                  if $_->can('to_json');
            }

        }
        elsif ( ref $value eq 'HASH' ) {

            for ( keys(%$value) ) {
                $data->{$attribute}->{$_} = $value->{$_}->to_json('RAW')
                  if $value->{$_}->can('to_json');
            }

        }
        elsif ( ref($value) && $value->can('to_json') ) {
            $data->{$attribute} = $value->to_json('RAW');
        }
        else {
            $data->{$attribute} = $value;
        }
    }
    return $data if ($raw);
    return $self->json_xs->encode($data);
}

sub new_from_json {

    my ( $self, %args ) = @_;
    my $json_xs = JSON::XS->new->allow_nonref;
    my $json    = $json_xs->decode( $args{json} );

    my %c_args;
    for my $attribute ( grep { defined $json->{ $_->{name} } }
        ( $self->meta->get_all_attributes ) )
    {

        my $name = $attribute->{name};
        if ( ref $json->{$name} eq 'ARRAY' ) {

            my $array = [];

            for my $json_object ( @{ $json->{$name} } ) {
                my $class       = $json_object->{ref};
                my $json_string = $json_xs->encode($json_object);
                push @$array, $class->new( json => $json_string );
            }

            $c_args{$name} = $array;

        }
        elsif ( ref $json->{$name} eq 'HASH' ) {

            if ( $json->{$name}->{ref} ) {
                my $class       = delete( $json->{$name}->{ref} );
                my $json_string = $json_xs->encode( $json->{$name} );
                $c_args{$name} = $class->new( json => $json_string );

            }
            else {

                my $hash = {};
                for my $key ( keys %{ $json->{$name} } ) {
                    my $json_object = $json->{$name}->{$key};
                    my $class       = $json_object->{ref};
                    my $json_string = $json_xs->encode($json_object);
                    $hash->{$key} = $class->new( json => $json_string );
                }
                $c_args{$name} = $hash;
            }

        }
        else {
            $c_args{$name} = $json->{$name};
        }
    }
    $c_args{json_xs} = $json_xs;
    return %c_args;

}

1;
