# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl BGPmon-CPM-Demo.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More;
BEGIN { use_ok('BGPmon::CPM::Prefix') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.
use BGPmon::CPM::Prefix;
use BGPmon::CPM::PList;
use BGPmon::CPM::Domain;


my $list = BGPmon::CPM::PList->new(name=>'test');
ok($list->save,"List creation failed");

my $domain_obj = BGPmon::CPM::Domain->new(domain=>'localhost');
$list->prefixes({prefix=>'127.0.0.1/32',watch_more_specifics=>1,watch_covering=>1,domains=>[{domain=>'localhost'}]});
ok($list->save,"Second Save Failed");

$list->add_or_edit_prefixes({prefix=>'127.0.0.2',watch_more_specifics=>0,
                         watch_covering=>1,
                         search_paths=>[{path=>"localhost CNAME localhost2"}],
                         authoritative_for=>[{domain=>"localhost"}],
                         domains=>[{domain=>'localhost'}]});
ok($list->save,"Third Save Failed");

$list->add_or_edit_prefixes({prefix=>'127.0.0.2',watch_more_specifics=>0,
                         watch_covering=>1,
                         search_paths=>[{path=>"localhost3 CNAME localhost4"}],
                         authoritative_for=>[{domain=>"localhost5"}],
                         domains=>[{domain=>'localhost6'}]});
ok($list->save,"fourth Save Failed");


my @prefixes = $list->prefixes;
ok(scalar(@prefixes) == 2,"prefixes has wrong cardinality " . scalar(@prefixes));

done_testing();
#ok($list->delete( cascade => 1 ),"Failed list delete");
