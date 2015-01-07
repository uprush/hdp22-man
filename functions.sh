#!/bin/bash

DEMO_HOME=`dirname $0`
DEMO_HOME=`cd $DEMO_HOME; pwd`

source $DEMO_HOME/conf/env.sh
source $DEMO_HOME/hdp_helper/scripts/directories.sh
source $DEMO_HOME/hdp_helper/scripts/usersAndGroups.sh

function escape_path() {
  IN_PATH=$1
  if [[ "x$IN_PATH" == "x" ]]; then
    echo ""
  else
    echo "$IN_PATH" | sed -e 's/\//\\\//g' > /tmp/escaped
    cat /tmp/escaped
  fi
}

function setup_common() {
  setup_jdk
  config_repo

  # install hadoop packages
  yum -y install hadoop hadoop-hdfs hadoop-libhdfs hadoop-yarn hadoop-mapreduce hadoop-client openssl

  # install Snappy and LZO
  yum -y install snappy snappy-devel
  # ln -sf /usr/lib64/libsnappy.so /usr/lib/hadoop/lib/native/.

  yum -y install lzo lzo-devel hadooplzo hadooplzo-native
}

function setup_jdk() {
  mkdir /usr/java
  cp /vagrant_data/jdk-7u67-linux-x64.tar /usr/java
  cd /usr/java
  tar xvf jdk-7u67-linux-x64.tar
  rm -f jdk-7u67-linux-x64.tar
  ln -s /usr/java/jdk1.7.0_67 /usr/java/default

  rm -f /usr/bin/java
  ln -s /usr/java/default/bin/java /usr/bin/java

  export JAVA_HOME=/usr/java/default
  export PATH=$JAVA_HOME/bin:$PATH

  echo "Using Java:"
  java -version
}

function config_repo() {
  wget -nv $HDP_REPO -O /etc/yum.repos.d/hdp.repo
}

function create_common_directories() {
  # YARN local directory
  mkdir -p $YARN_LOCAL_DIR;
  chown -R $YARN_USER:$HADOOP_GROUP $YARN_LOCAL_DIR;
  chmod -R 755 $YARN_LOCAL_DIR;

  # YARN local log directories
  mkdir -p $YARN_LOCAL_LOG_DIR;
  chown -R $YARN_USER:$HADOOP_GROUP $YARN_LOCAL_LOG_DIR;
  chmod -R 755 $YARN_LOCAL_LOG_DIR;

  # HDFS log directory
  mkdir -p $HDFS_LOG_DIR;
  chown -R $HDFS_USER:$HADOOP_GROUP $HDFS_LOG_DIR;
  chmod -R 755 $HDFS_LOG_DIR;

  # YARN log directory
  mkdir -p $YARN_LOG_DIR;
  chown -R $YARN_USER:$HADOOP_GROUP $YARN_LOG_DIR;
  chmod -R 755 $YARN_LOG_DIR;

  # Hadoop pid directory
  mkdir -p $HDFS_PID_DIR;
  chown -R $HDFS_USER:$HADOOP_GROUP $HDFS_PID_DIR;
  chmod -R 755 $HDFS_PID_DIR

  # YARN pid directory
  mkdir -p $YARN_PID_DIR;
  chown -R $YARN_USER:$HADOOP_GROUP $YARN_PID_DIR;
  chmod -R 755 $YARN_PID_DIR;

  mkdir -p $YARN_PID_DIR2;
  chown -R $YARN_USER:$HADOOP_GROUP $YARN_PID_DIR2;
  chmod -R 755 $YARN_PID_DIR2;

  # MapReduce log directory
  mkdir -p $MAPRED_LOG_DIR;
  chown -R $MAPRED_USER:$HADOOP_GROUP $MAPRED_LOG_DIR;
  chmod -R 755 $MAPRED_LOG_DIR;

  # MapReduce pid directory
  mkdir -p $MAPRED_PID_DIR;
  chown -R $MAPRED_USER:$HADOOP_GROUP $MAPRED_PID_DIR;
  chmod -R 755 $MAPRED_PID_DIR;
}

# Configure core hadoop
function configure_core_hadoop() {
  HELPER_CONF_DIR=$DEMO_HOME/hdp_helper/configuration_files/core_hadoop

  # hadoop-env.sh
  sed -i "s/TODO-JDK-PATH/$JAVA_HOME_PATH/g" $HELPER_CONF_DIR/hadoop-env.sh

  # yarn-env.sh
  sed -i "s/TODO-JDK-PATH/$JAVA_HOME_PATH/g" $HELPER_CONF_DIR/yarn-env.sh

  # mapred-env.sh
  sed -i "s/TODO-JDK-PATH/$JAVA_HOME_PATH/g" $HELPER_CONF_DIR/mapred-env.sh

  # core-site.xml
  MASTER_HOSTNAME=`cat $DEMO_HOME/conf/cluster/masters`
  sed -i "s/TODO-NAMENODE-HOSTNAME:PORT/$MASTER_HOSTNAME:8020/g" $HELPER_CONF_DIR/core-site.xml

  # hdfs-site.xml
  ESCAPED_LIST_OF_DATA_DIRS=`escape_path "$LIST_OF_DATA_DIRS"`
  sed -i "s/TODO-DFS-DATA-DIR/$ESCAPED_LIST_OF_DATA_DIRS/g" $HELPER_CONF_DIR/hdfs-site.xml
  sed -i "s/TODO-NAMENODE-HOSTNAME/$MASTER_HOSTNAME/g" $HELPER_CONF_DIR/hdfs-site.xml

  ESCAPED_LIST_OF_NAMENODE_DIRS=`escape_path "$LIST_OF_NAMENODE_DIRS"`
  sed -i "s/TODO-DFS-NAME-DIR/$ESCAPED_LIST_OF_NAMENODE_DIRS/g" $HELPER_CONF_DIR/hdfs-site.xml

  # yarn-site.xml
  sed -i "s/TODO-RESOURCEMANAGERNODE-HOSTNAME/$MASTER_HOSTNAME/g" $HELPER_CONF_DIR/yarn-site.xml
  sed -i "s/--- Secure cluster/Secure cluster/g" $HELPER_CONF_DIR/yarn-site.xml # fix error xml syntax. bug?

  ESCAPED_LIST_OF_YARN_LOCAL_DIRS=`escape_path "$LIST_OF_YARN_LOCAL_DIRS"`
  sed -i "s/\/hadoop\/yarn\/local/$ESCAPED_LIST_OF_YARN_LOCAL_DIRS/g" $HELPER_CONF_DIR/yarn-site.xml

  ESCAPED_LIST_OF_YARN_LOCAL_LOG_DIRS=`escape_path "$LIST_OF_YARN_LOCAL_LOG_DIRS"`
  sed -i "s/\/hadoop\/yarn\/log/$ESCAPED_LIST_OF_YARN_LOCAL_LOG_DIRS/g" $HELPER_CONF_DIR/yarn-site.xml

  # mapred-site.xml
  sed -i "s/TODO-JOBHISTORYNODE-HOSTNAME/$MASTER_HOSTNAME/g" $HELPER_CONF_DIR/mapred-site.xml

  # copy settings
  rm -rf $HADOOP_CONF_DIR
  mkdir -p $HADOOP_CONF_DIR

  cp $HELPER_CONF_DIR/* $HADOOP_CONF_DIR

  # set permissions
  chown -R $HDFS_USER:$HADOOP_GROUP $HADOOP_CONF_DIR/../
  chmod -R 755 $HADOOP_CONF_DIR/../
}

