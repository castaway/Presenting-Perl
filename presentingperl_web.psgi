use strict;
use warnings;

use PresentingPerl::Web;

my $app = PresentingPerl::Web->apply_default_middlewares(PresentingPerl::Web->psgi_app);
$app;

