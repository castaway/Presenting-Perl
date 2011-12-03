package PresentingPerl::Schema::ResultSet::Announcement;;
use strict;
use warnings;

use base 'DBIx::Class::ResultSet';

sub top_n {
    my ($self, $n) = @_;

    return $self->search({}, { rows => $n });
}

1;
