package Test::Cards::JSON;

use strict;

use Exporter 'import';
our @EXPORT_OK = qw(copy_by_json);    # symbols to export on request

use Test::Deep;
use JSON::XS;

sub copy_by_json {
    my ($obj) = @_;

    my $class = ref($obj);

    my $json_xs = JSON::XS->new->allow_nonref;
    my $json    = $obj->to_json();
    my $new     = $class->new( json => $json );
    cmp_deeply(
        $json_xs->decode($json),
        $json_xs->decode( $new->to_json ),
        "json $class seem to very matches"
    );
    return $new;
}

1;
