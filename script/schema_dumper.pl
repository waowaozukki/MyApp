#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use DBI;
use Teng::Schema::Dumper;
use Path::Class qw/file/;

my $teng_schema_class = $ARGV[0] or die "you must input teng_schema_class";

my $mysql_schema_path = $ARGV[1] or die "you must input mysql schema path";

my $mysqld = Test::mysqld->new(
    my_cnf => {
        'skip-networking' => '', # no TCP socket
    }
) or die $Test::mysqld::errstr;

my $dbh = DBI->connect("dbi:mysql:dbname=minecraft", 'root', 'root', +{mysql_enable_utf8 => 1}) or die "can't create dbh";

my $schema = Teng::Schema::Dumper->dump(
    dbh       => $dbh,
    namespace => $teng_schema_class,
);

print $schema;
