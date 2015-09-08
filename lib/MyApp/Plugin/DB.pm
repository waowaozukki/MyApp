package MyApp::Plugin::DB;
use strict;
use warnings;
use Amon2::Util;
use Teng::Schema::Loader;
use Teng;

sub init {
    my ($class, $c) = @_;
    Amon2::Util::add_method(
        $c,
        'db',
        sub {
            my $self = shift;

            $self->{db} ||= do {
                my $dbh = DBI->connect("DBI:mysql:minecraft:localhost",'root','root');
                my $schema = Teng::Schema::Loader->load(
                    namespace => 'MyApp::DB',
                    dbh       => $dbh,
                );
                Teng->new(
                    dbh    => $dbh,
                    schema => $schema,
                );
            }
        }
    );
}
1;
