#!/bin/bash

DEMO_HOME=`dirname $0`
DEMO_HOME=`cd $DEMO_HOME; pwd`

source $DEMO_HOME/functions.sh

# Create directories
function create_slave_directories() {
  # Datanode directories
  mkdir -p $DFS_DATA_DIR;
  chown -R $HDFS_USER:$HADOOP_GROUP $DFS_DATA_DIR;
  chmod -R 750 $DFS_DATA_DIR;
}

setup_common
create_common_directories
create_slave_directories
configure_core_hadoop

echo "Completed successfully: setup-slaves"
