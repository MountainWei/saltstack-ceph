#!/bin/bash

echo 'hello,purge ceph now.'
ceph-deploy uninstall $1 $2 $3 $4
ceph-deploy purgedata $1 $2 $3 $4
ceph-deploy forgetkeys
ceph-deploy purge $1 $2 $3 $4
echo 'bye,purge end.'
