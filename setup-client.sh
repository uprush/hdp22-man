#!/bin/bash
#
# Set up metastore
#
DEMO_HOME=`dirname $0`
DEMO_HOME=`cd $DEMO_HOME; pwd`

source $DEMO_HOME/functions.sh

function install_hadoop_client() {
  yum -y install hadoop-client hadoop-hdfs-client hadoop-yarn-client
}

install_hadoop_client
# TODO: configure client

echo "Completed successfully: setup-client"
