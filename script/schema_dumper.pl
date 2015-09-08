#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use Test::mysqld;
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

my $dbh = DBI->connect(
    $mysqld->dsn.';mysql_multi_statements=1',
) or die "can't create dbh";

$dbh->do('create database test_db');
my $sql = "use test_db;\n";
$sql   .= "set names utf8;\n";
$sql   .= file($mysql_schema_path)->slurp(iomode => '<:encoding(UTF-8)');
$dbh->do($sql);

my $schema = Teng::Schema::Dumper->dump(
    dbh       => $dbh,
    namespace => $teng_schema_class,
#    inflate   => $inflate_conf, #inlateを入れたい時はここにほげほげ
);

## なんか入れ込みたい時は、ここで強引に置換
#$schema =~ s!Teng\:\:Schema\:\:Declare\;!Teng\:\:Schema\:\:Declare\;\nuse Time::Piece\;!;

print $schema;
