#!/bin/bash
#
# Set up metastore
#
DEMO_HOME=`dirname $0`
DEMO_HOME=`cd $DEMO_HOME; pwd`

source $DEMO_HOME/functions.sh

function install_tez() {
  echo "Installing Tez"
  yum -y install tez

  # Create tmp dir (not required)
  sudo -u $HDFS_USER hdfs dfs -mkdir /tmp
  sudo -u $HDFS_USER hdfs dfs -chmod 777 /tmp
}

function configure_tez() {
  echo "Configuring Tez"
  HELPER_CONF_DIR=$DEMO_HOME/hdp_helper/configuration_files/tez

  # tez-site.xml
  sed -i "s/TODO-CALCULATE-MEMORY-SETTINGS/$TEZ_APPMASTER_RAM_MB/g" $HELPER_CONF_DIR/tez-site.xml

  # copy settings
  rm -r $TEZ_CONF_DIR
  mkdir -p $TEZ_CONF_DIR

  cp $HELPER_CONF_DIR/* $TEZ_CONF_DIR

  # set permissions
  chown -R $TEZ_USER:$HADOOP_GROUP $TEZ_CONF_DIR/../
  chmod -R 755 $TEZ_CONF_DIR/../
}

function upload_to_hdfs() {
  echo "Uplaoding Tez to HDFS"
  # sudo -u $HDFS_USER hdfs dfs -mkdir -p /hdp/apps/current/tez/
  sudo -u $HDFS_USER hdfs dfs -mkdir -p /hdp/apps/$HDP_VERSION/tez/

  sudo -u $HDFS_USER hdfs dfs -put /usr/hdp/current/tez-client/lib/tez.tar.gz /hdp/apps/$HDP_VERSION/tez/
  sudo -u $HDFS_USER hdfs dfs -chown -R hdfs:hadoop /hdp
  sudo -u $HDFS_USER hdfs dfs -chmod -R 555 /hdp/apps/$HDP_VERSION/tez
  sudo -u $HDFS_USER hdfs dfs -chmod -R 444 /hdp/apps/$HDP_VERSION/tez/tez.tar.gz
}

install_tez
configure_tez
upload_to_hdfs

echo "Completed successfully: setup-tez"
