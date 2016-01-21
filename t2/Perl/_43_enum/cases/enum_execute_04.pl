#!perl -w
#Test execute for select_1;
use DBI;
use Test::More;
#use strict;
#Test execute for insert index.
use vars qw($db $port $hostname); 

$db=$ARGV[0];
$port=$ARGV[2];
$hostname=$ARGV[1];
my $user="dba";
my $pass="";

my $dsn="dbi:cubrid:database=$db;host=$hostname;port=$port";

my $dbh;

$dbh=DBI->connect($dsn, $user, $pass,{RaiseError => 1}) or die "connect error: $dbh->errstr";

$dbh->do("drop table if EXISTS enume04;") or die "drop error: $dbh->errstr";
$dbh->do("create class enume04(i INT, working_days ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday') not null,answers ENUM('Yes', 'No', 'Cancel'))") or die "create error: $dbh->errstr";
$dbh->do("insert into enume04 values(1,1,1);") or die "insert error:$dbh-errstr";
my $sth;

#############################################
ok($sth=$dbh->prepare("select * from enume04;"),"Prepare select is ok");
$sth->execute;
my $arry=$sth->fetchall_arrayref({}) or die "Arry error:$dbh->errstr";

my $i=0;
my @id=(1);
my @e1=('Monday');
my @e2=('Yes');
foreach my $row(@$arry){
 is($row->{'i'},$id[$i],"fetchall_arrayref({}) ok");
 is($row->{'working_days'},$e1[$i],"fetchall_arrayref({}) ok");
 is($row->{'answers'},$e2[$i],"fetchall_arrayref({}) ok");
 
 $i++;
}
$sth->finish();


##############################################
ok($sth=$dbh->prepare("select cast(working_days as int), cast(answers as int) from enume04"),"Prepare select is ok");
$sth->execute;
my $arry=$sth->fetchall_arrayref({}) or die "Arry error:$dbh->errstr";

my $i=0;
my @id=(1);
my @e1=(1);
foreach my $row(@$arry){
 is($row->{'cast(working_days as integer)'},$id[$i],"fetchall_arrayref({}) ok");
 is($row->{'cast(answers as integer)'},$e1[$i],"fetchall_arrayref({}) ok");
 $i++;
}
$sth->finish();

###############################################

ok($sth=$dbh->prepare("select i from enume04;"),"Prepare select is ok");
$sth->execute;
my $arry=$sth->fetchall_arrayref({}) or die "Arry error:$dbh->errstr";

my $i=0;
my @id=(1);
foreach my $row(@$arry){
 is($row->{'i'},$id[$i],"fetchall_arrayref({}) ok");
 $i++;
}

$sth->finish();


done_testing();
$dbh -> disconnect();



