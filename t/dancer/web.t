
BEGIN { $ENV{DANCER_APPHANDLER} = 'PSGI' }; # Force PSGI server

use FindBin;
use lib "$FindBin::Bin/../lib";
use CrabCakes::Web;

use Test::WWW::Mechanize::PSGI;
my $mech = Test::WWW::Mechanize::PSGI->new( app => CrabCakes::Web->dance );
$mech->get_ok('/');  
