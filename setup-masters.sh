#!/bin/bash

DEMO_HOME=`dirname $0`
DEMO_HOME=`cd $DEMO_HOME; pwd`

source $DEMO_HOME/functions.sh

# Create directories
function create_master_directories() {
  # NN directories
  mkdir -p $DFS_NAME_DIR;
  chown -R $HDFS_USER:$HADOOP_GROUP $DFS_NAME_DIR;
  chmod -R 755 $DFS_NAME_DIR;
}

setup_common
create_common_directories
create_master_directories
configure_core_hadoop

echo "Completed successfully: setup-masters"
