use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";

use Test::More tests => 2;

use CrabCakes::Model::Card;


# the order is important
use CrabCakes::Web;
use Dancer::Test;

route_exists [GET => '/'], 'a route handler is defined for /';
response_status_is ['GET' => '/'], 200, 'response status is 200 for /';
