#!/bin/bash
#
# Set up YARN
#
DEMO_HOME=`dirname $0`
DEMO_HOME=`cd $DEMO_HOME; pwd`

source $DEMO_HOME/functions.sh

function copy_to_hdfs() {
  echo "Copying YARN libraries to HDFS"
  sudo -u $HDFS_USER hdfs dfs -mkdir -p /hdp/apps/2.2.0.0-2041/mapreduce/
  sudo -u $HDFS_USER hdfs dfs -put /usr/hdp/current/hadoop-client/mapreduce.tar.gz /hdp/apps/2.2.0.0-2041/mapreduce/
  sudo -u $HDFS_USER hdfs dfs -chown -R hdfs:hadoop /hdp
  sudo -u $HDFS_USER hdfs dfs -chmod -R 555 /hdp/apps/2.2.0.0-2041/mapreduce
  sudo -u $HDFS_USER hdfs dfs -chmod -R 444 /hdp/apps/2.2.0.0-2041/mapreduce/mapreduce.tar.gz
}

function configure_yarn() {
  echo "Configuring yarn-site.xml"
  # TODO: replace the 'TODO-xxxx' in yarn-site.xml (memory settings)
  # sed -i "s/TODO-xxxx/foo/g" $DEMO_HOME/hdp_helper/configuration_files/core_hadoop/yarn-site.xml
  HELPER_CONF_DIR=$DEMO_HOME/hdp_helper/configuration_files/core_hadoop

  MASTER_HOSTNAME=`cat $DEMO_HOME/conf/cluster/masters`
  sed -i "s/TODO-RESOURCEMANAGERNODE-HOSTNAME/$MASTER_HOSTNAME/g" $HELPER_CONF_DIR/yarn-site.xml
  sed -i "s/TODO-TIMELINESERVER-HOSTNAME/$MASTER_HOSTNAME/g" $HELPER_CONF_DIR/yarn-site.xml
  sed -i "s/TODO-JOBHISTORYNODE-HOSTNAME/$MASTER_HOSTNAME/g" $HELPER_CONF_DIR/yarn-site.xml
  sed -i "s/TODO-YARN-LOCAL-DIR/$YARN_LOCAL_DIR/g" $HELPER_CONF_DIR/yarn-site.xml
  sed -i "s/TODO-YARN-LOCAL-LOG-DIR/$YARN_LOCAL_LOG_DIR/g" $HELPER_CONF_DIR/yarn-site.xml

  cp $HELPER_CONF_DIR/yarn-site.xml $YARN_CONF_DIR
  chown hdfs:hadoop $YARN_CONF_DIR/yarn-site.xml
}

copy_to_hdfs
configure_yarn

echo "Completed successfully: setup-yarn"
