#!/bin/bash
#
# Set up Zookeeper
#

DEMO_HOME=`dirname $0`
DEMO_HOME=`cd $DEMO_HOME; pwd`

source $DEMO_HOME/functions.sh

function install_zk() {
  apt-get install zookeeper
  usermod zookeeper -s /bin/bash
}

function create_zk_dir() {
  # log dir
  mkdir -p $ZOOKEEPER_LOG_DIR
  chown -R $ZOOKEEPER_USER:$HADOOP_GROUP $ZOOKEEPER_LOG_DIR
  chmod -R 755 $ZOOKEEPER_LOG_DIR

  # pid dir
  mkdir -p $ZOOKEEPER_PID_DIR
  chown -R $ZOOKEEPER_USER:$HADOOP_GROUP $ZOOKEEPER_PID_DIR
  chmod -R 755 $ZOOKEEPER_PID_DIR

  # data dir
  mkdir -p $ZOOKEEPER_DATA_DIR
  chmod -R 755 $ZOOKEEPER_DATA_DIR
  chown -R $ZOOKEEPER_USER:$HADOOP_GROUP $ZOOKEEPER_DATA_DIR

  # initialize myid file
  # only work for single node zk cluster
  echo '1' > $ZOOKEEPER_DATA_DIR/myid
}

function configure_zk() {
  ZOO_HELPER_DIR=$DEMO_HOME/hdp_helper/configuration_files/zookeeper
  source $DEMO_HOME/conf/env.sh
  MASTER_HOSTNAME=`cat $DEMO_HOME/conf/cluster/masters`

  ESCAPED_ZOOKEEPER_DATA_DIR=`escape_path "$ZOOKEEPER_DATA_DIR"`
  sed -i "s/TODO-ZOOKEEPER-DATA-DIR/$ESCAPED_ZOOKEEPER_DATA_DIR/g" $ZOO_HELPER_DIR/zoo.cfg
  sed -i "s/TODO-ZKSERVER-HOSTNAME/$MASTER_HOSTNAME/g" $ZOO_HELPER_DIR/zoo.cfg

  rm -r $ZOOKEEPER_CONF_DIR
  mkdir -p $ZOOKEEPER_CONF_DIR

  cp $ZOO_HELPER_DIR/* $ZOOKEEPER_CONF_DIR/

  chmod a+x $ZOOKEEPER_CONF_DIR/
  chown -R $ZOOKEEPER_USER:$HADOOP_GROUP $ZOOKEEPER_CONF_DIR/../
  chmod -R 755 $ZOOKEEPER_CONF_DIR/../
}

install_zk
create_zk_dir
configure_zk

echo "Completed successfully: setup-zookeeper"
