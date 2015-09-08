
=pod
package MyApp;
use strict;
use warnings;
use parent qw/Amon2/;
our $VERSION='0.01';
use 5.008001;

#__PACKAGE__->load_plugins(qw/
#    +MyApp::Plugin::DB
#/);
=cut

package MyApp;
use strict;
use warnings;
use utf8;
our $VERSION='0.01';
use 5.008001;

use DBI;
use Teng::Schema::Loader;

use parent qw/Amon2/;
# Enable project local mode.
__PACKAGE__->make_local_context();

sub db {
        my $self = shift;
        if ( !defined $self->{db} ) {
                my $conf = $self->config->{'DBI'}
                        or die "missing configuration for 'DBI'";
                my $dbh = DBI->connect(@{$conf});
#               $schema ||= Teng::Schema::Loader->load(
                $self->{db} = Teng::Schema::Loader->load(
                        namespace => 'MyApp::DB',
                        dbh       => $dbh,
                );
#               $self->{db} = MyApp::DB->new(
#                       dbh    => $dbh,
#                       schema => $schema,
#               );
        }
        return $self->{db};
}

=pod
my $schema = MyApp::DB::Schema->instance;
sub db {
    my $c = shift;
    if (!exists $c->{db}) {
        my $conf = $c->config->{DBI}
            or die "Missing configuration about DBI";
        $c->{db} = MyApp::DB->new(
            schema       => $schema,
            connect_info => [@$conf],
            # I suggest to enable following lines if you are using mysql.
            # on_connect_do => [
            #     'SET SESSION sql_mode=STRICT_TRANS_TABLES;',
            # ],
        );
    }
    $c->{db};
}
=cut

1;
__END__

=head1 NAME

MyApp - MyApp

=head1 DESCRIPTION

This is a main context class for MyApp

=head1 AUTHOR

MyApp authors.

