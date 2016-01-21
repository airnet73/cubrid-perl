#!perl -w

use DBI;
use DBD::cubrid;
use Test::More;
use strict;

use vars qw($db $port $hostname); 

$db=$ARGV[0];
$port=$ARGV[2];
$hostname=$ARGV[1];
my $user="dba";
my $pass="";

my $data_source="dbi:cubrid:database=$db;host=$hostname;port=$port";

my $dbh;

eval {$dbh=DBI->connect($data_source, $user, $pass,
	{RaiseError => 1});};
if($@)
{
   print "An error occurred ($@), continuing \n";
}

$dbh -> do("drop table if EXISTS tdb ;") or die "drop error: $dbh->errstr";
$dbh -> do("create table tdb (age int, firstName char(20), lastName char(10), income float, sex char(1)) ;") or die "create error:$dbh->errstr";



$dbh->do("insert into tdb values (30,'john','poul',13000,'F'),(26,'Bobo','Li',9000,'M'),(33,'Jacky','Wang',16000,'F');") or die  $dbh->err ." insert error\n";

$dbh->do("insert into tdb values (30,'john','poul',13000,35)") or die  "insert error:  "    . $dbh->errstr  ."\n";

=head; 
my $err=$dbh->errstr;
print "$err\n";

if($err){
   print "$err\n";
}else{
   print "no error\n";
}
=cut;

$dbh->disconnect();



$dbh -> disconnect();



