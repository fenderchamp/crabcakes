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
route_exists [GET => '/help'], 'a route handler is defined for /help';
response_status_is ['GET' => '/help'], 200, 'response status is 200 for /help';

route_exists [GET => '/taintone'], 'a route handler is defined for /taintone';
response_status_is ['GET' => '/taintone'], 404, 'response status is 404 for /taintone';
