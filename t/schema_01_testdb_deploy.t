use strict;
use warnings;
use Test::More;

# Attempt to deploy the schema as a test database

use PresentingPerl::Schema;

my $schema;
my $dir = "t/var/";
my $file = "test.db";

# Check the var directory exists for our testing.
unless(-d $dir) {
    mkdir($dir);
}

# Check we don't already have a test database prior to stomping all over it...
if(-e $dir . $file) {
    plan skip_all => 'Test database file already exists.  Skipping creation.';
} else {
    plan tests => 2;
}

ok($schema = PresentingPerl::Schema->connect("dbi:SQLite:$dir$file"), "Creating a schema object");
$schema->deploy({ add_drop_table => 0 }, $dir);

# Check the file exists
my $file_exists = (-e $dir . $file);

ok($file_exists, "Test database file exists");

