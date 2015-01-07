#!/bin/bash
#
# Start the EC2 isntance for Hadoop master.
#

DEMO_HOME=`dirname $0`
DEMO_HOME=`cd $DEMO_HOME; pwd`

MASTER_FQDN='master1.kintoki.mt'

source $DEMO_HOME/conf/env.sh

# start VM
vagrant status master1 | grep 'master1 .*running'
if [[ $? -ne 0 ]]; then
  echo "Starting master1, FQDN: ${MASTER_FQDN}"
  vagrant up master1
fi

# wait for instance to be ready
sleep 1

# Note master private FQDN
rm -f $DEMO_HOME/conf/cluster/masters
mkdir -p $DEMO_HOME/conf/cluster


echo $MASTER_FQDN > $DEMO_HOME/conf/cluster/masters
cp $DEMO_HOME/conf/cluster/masters $DEMO_HOME/conf/cluster/all_nodes
echo "Master private FQDN: `cat $DEMO_HOME/conf/cluster/masters`"
