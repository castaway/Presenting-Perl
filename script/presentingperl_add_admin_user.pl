#!/usr/bin/perl

use strict;
use warnings;

=head1 SYNOPSIS

    perl presentingperl_add_admin_user.pl \
        -dsn    dbi:SQLite:idiotbox.db \
        -email  <email> \
        -first  <first> \
        -last   <last>  \
        -pass   <pass>  \
        -user

This script creates users within the Presenting Perl database.

=cut

use Authen::Passphrase::SaltedDigest;
use Getopt::Long;
use Pod::Usage;
use PresentingPerl::Schema;

my ($cli_dsn, $cli_email, $cli_first, $cli_last, $cli_pass, $cli_user, $DEBUG);

GetOptions(
    'dsn=s'       => \$cli_dsn,
    'email=s'     => \$cli_email,
    'first=s'     => \$cli_first,
    'last=s'      => \$cli_last,
    'pass=s'      => \$cli_pass,
    'user=s'      => \$cli_user,
    'v'           => \$DEBUG,
) or die pod2usage;

unless(defined($cli_dsn)) {
    pod2usage("No DSN specified");
}

unless(defined($cli_email)) {
    pod2usage("No email specified");
}

unless(defined($cli_first)) {
    pod2usage("No first name specified");
}

unless(defined($cli_last)) {
    pod2usage("No last name specified");
}

unless(defined($cli_pass)) {
    pod2usage("No password specified");
}

unless(defined($cli_user)) {
    pod2usage("No username specified");
}

my $schema = PresentingPerl::Schema->connect($cli_dsn);



my $user = $schema->resultset('User')->create({
    active        => 1,
    email_address => $cli_email,
    first_name    => $cli_first,
    last_name     => $cli_last,
    password      => Authen::Passphrase::SaltedDigest->new(
        algorithm     => "SHA-1", 
        salt_random   => 4,
        passphrase    => $cli_pass,
    ),
    username      => $cli_user,
    user_roles    => [ { role => { role => 'admin' } } ],
});

