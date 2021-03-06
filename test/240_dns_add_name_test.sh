#! /bin/bash

. ./config.sh

C1=10.2.0.78
C2=10.2.0.34
NAME1=seeone.weave.local
NAME2=seetwo.weave.local

start_suite "Add and remove names on a single host"

weave_on $HOST1 launch-dns 10.2.254.1/24 --no-cache

start_container          $HOST1 $C2/24 --name=c2
start_container_with_dns $HOST1 $C1/24 --name=c1

weave_on $HOST1 dns-add $C2 c2 -h $NAME2

assert_dns_record $HOST1 c1 $NAME2 $C2

weave_on $HOST1 dns-add $C1 c1 -h $NAME1

assert "exec_on $HOST1 c1 getent hosts $C1 | tr -s ' '" "$C1 $NAME1"

weave_on $HOST1 dns-remove $C1 c1

assert_no_dns_record $HOST1 c1 $NAME1

end_suite
