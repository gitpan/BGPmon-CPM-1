use Test::More;
use Data::Dumper;
BEGIN { use_ok('BGPmon::CPM::Prefix::Finder') };

use BGPmon::CPM::Prefix::Finder;

## this ip address belongs to NAB. This call should find source, inetnum, 
## netname, orgid
my $test_ip = "164.53.220.193";
my %org_data = BGPmon::CPM::Prefix::Finder::expandIP($test_ip); 
ok($org_data{'source'} eq "APNIC","expected: APNIC got: ".$org_data{'source'});
ok($org_data{'netname'} eq "NABAUS");
ok($org_data{'inetnum'} eq "164.53.0.0 - 164.53.255.255");
ok($org_data{'orgid'} eq "NAB");

## translate the inetnum to a list of prefixes
my @prefixes = BGPmon::CPM::Prefix::Finder::inetnum2prefixes
                                                     ($org_data{'inetnum'});
ok(scalar(@prefixes) == 1, "Expected only 1 prefix");
ok($prefixes[0] eq "164.53.0.0/16","Expected 164.53.0.0/16 Got ".$prefixes[0]);

## this ip address belongs to ntt america. This call should find source, 
## inetnume, netname, orghandle
$test_ip = "128.242.112.97";
%org_data = BGPmon::CPM::Prefix::Finder::expandIP($test_ip); 
ok($org_data{'source'} eq "ARIN", "expected: ARIN got: " . $org_data{'source'});
ok($org_data{'netname'} eq "NTTA-128-242", "expected: NTTA-128-242 got: " 
   . $org_data{'netname'});
ok($org_data{'inetnum'} eq "128.242.0.0-128.242.255.255",
   "expected 128.242.0.0-128.242.255.255 got: " . $org_data{'inetnum'});
ok($org_data{'orghandle'} eq "NTTAM-1","expected NTTAM-1 got: " 
   . $org_data{'orghandle'});

## translate the inetnum to a list of prefixes
@prefixes = BGPmon::CPM::Prefix::Finder::inetnum2prefixes($org_data{'inetnum'});
ok(scalar(@prefixes) == 1, "Expected only 1 prefix");
ok($prefixes[0] eq "128.242.0.0/16","Expected 128.242.0.0/16 Got " 
   . $prefixes[0]);

## in a case where we are able to get an orghandle, we should be able to expand
## to a list of inetnums
## each of these nets being owned by that company
my @nets = BGPmon::CPM::Prefix::Finder::orghandle2nets("NTTAM-1");
foreach my $net (@nets){
  push @prefixes,BGPmon::CPM::Prefix::Finder::inetnum2prefixes($net);
}
ok(scalar(@prefixes) > 0,"Expected several prefixes, but got 0");

## test the dns expansion
my @domains = ("colostate.edu");
my %dns_list;
%ip_list = BGPmon::CPM::Prefix::Finder::expandDomainToIPs(\@domains);
ok(%ip_list,"list should be defined");

done_testing();
