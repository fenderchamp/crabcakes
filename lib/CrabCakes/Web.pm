package CrabCakes::Web;
use Dancer ':syntax';

our $VERSION = '0.1';

get '/help' => sub {
    template 'index';
};

get '/' => sub {
    send_file '/crabcakes.html'
};

get '/klondike' => sub {
    send_file '/klondike.html'
};
true;
