use strict;
use warnings;

use Catapulse::Web;

my $app = Catapulse::Web->apply_default_middlewares(Catapulse::Web->psgi_app);
$app;

