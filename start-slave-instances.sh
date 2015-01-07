#!/bin/bash
#
# Start the EC2 isntances for Hadoop slaves.
#

DEMO_HOME=`dirname $0`
DEMO_HOME=`cd $DEMO_HOME; pwd`

source $DEMO_HOME/conf/env.sh

SLAVE1_FQDN='slave1.kintoki.mt'
SLAVE2_FQDN='slave2.kintoki.mt'

# start VM
vagrant status slave1 | grep 'slave1 .*running'
if [[ $? -ne 0 ]]; then
  echo "Starting slave1..."
  vagrant up slave1
fi

echo
vagrant status slave2 | grep 'slave2 .*running'
if [[ $? -ne 0 ]]; then
  echo "Starting slave2..."
  vagrant up slave2
fi

# wait for instance to be ready
sleep 1

echo $SLAVE1_FQDN > $DEMO_HOME/conf/cluster/slaves
echo $SLAVE2_FQDN >> $DEMO_HOME/conf/cluster/slaves
cat $DEMO_HOME/conf/cluster/slaves >> $DEMO_HOME/conf/cluster/all_nodes

echo
echo "Slaves private FQDNs:"
cat $DEMO_HOME/conf/cluster/slaves
