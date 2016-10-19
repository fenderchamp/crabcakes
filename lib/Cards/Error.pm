package Cards::Error;

use Moose;
extends 'Throwable::Error';
with 'Cards::Role::JSON';

sub _json_fields { qw(message) }

1;
