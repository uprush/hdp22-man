#!/bin/bash
#
# Set up metastore
#
DEMO_HOME=`dirname $0`
DEMO_HOME=`cd $DEMO_HOME; pwd`

source $DEMO_HOME/functions.sh

function install_hive() {
  yum -y install hive-hcatalog
  usermod $HIVE_USER -s /bin/bash

  yum -y install mysql-connector-java*

  # The latest connector is required by mysql 5.6
  # wget $MYSQL_CONNECTOR_URL -O /usr/lib/hive/lib/mysql-connector-java-5.1.33-bin.jar
}

function create_hive_log_dir() {
  echo "Creating hive log directories."
  mkdir -p $HIVE_LOG_DIR
  chown -R $HIVE_USER:$HADOOP_GROUP $HIVE_LOG_DIR
  chmod -R 777 $HIVE_LOG_DIR
}

function configure_hive() {
  echo "Configuring hive."
  HELPER_CONF_DIR=$DEMO_HOME/hdp_helper/configuration_files/hive

  # hive-site.xml
  MASTER_HOSTNAME=`cat $DEMO_HOME/conf/cluster/masters`
  sed -i "s/TODO-HIVE-METASTORE-DB-CONNECTION-DRIVER-NAME/$METASTORE_DB_DRIVER/g" $HELPER_CONF_DIR/hive-site.xml
  sed -i "s/TODO-HIVE-METASTORE-DB-PASSWORD/$METASTORE_DB_PASSWORD/g" $HELPER_CONF_DIR/hive-site.xml
  sed -i "s/TODO-HIVE-METASTORE-DB-SERVER/$METASTORE_DB_HOST/g" $HELPER_CONF_DIR/hive-site.xml
  sed -i "s/TODO-HIVE-METASTORE-DB-PORT/$METASTORE_DB_PORT/g" $HELPER_CONF_DIR/hive-site.xml
  sed -i "s/TODO-HIVE-METASTORE-DB-NAME/$METASTORE_DB_NAME/g" $HELPER_CONF_DIR/hive-site.xml
  sed -i "s/TODO-HIVE-METASTORE-DB-USER-NAME/$METASTORE_DB_USER/g" $HELPER_CONF_DIR/hive-site.xml

  # use the embamed metastore server
  sed -i "s/ thrift:\/\/\$Hive_Metastore_Server_Host_Machine_FQDN //g" $HELPER_CONF_DIR/hive-site.xml

  # copy settings
  rm -r $HIVE_CONF_DIR
  mkdir -p $HIVE_CONF_DIR

  cp $HELPER_CONF_DIR/* $HIVE_CONF_DIR

  # set permissions
  chown -R $HIVE_USER:$HADOOP_GROUP $HIVE_CONF_DIR/../
  chmod -R 755 $HIVE_CONF_DIR/../
}

function create_hdfs_dir() {
  echo "Creating hive directories on HDFS."
  # Hive user home
  sudo -u $HDFS_USER hadoop fs -mkdir -p /user/$HIVE_USER
  sudo -u $HDFS_USER hadoop fs -chown $HIVE_USER:$HDFS_USER /user/$HIVE_USER

  # Warehouse dir
  sudo -u $HDFS_USER hadoop fs -mkdir -p /apps/hive/warehouse
  sudo -u $HDFS_USER hadoop fs -chown -R $HIVE_USER:$HDFS_USER /apps/hive
  sudo -u $HDFS_USER hadoop fs -chmod -R 775 /apps/hive

  # Hive scratch dir
  sudo -u $HDFS_USER hadoop fs -mkdir -p /tmp/scratch
  sudo -u $HDFS_USER hadoop fs -chown -R $HIVE_USER:$HDFS_USER /tmp/scratch
  sudo -u $HDFS_USER hadoop fs -chmod -R 777 /tmp/scratch
}

function init_and_start_metastore() {
  echo "Starting metastore server."
  /usr/lib/hive/bin/schematool -initSchema -dbType mysql
  sudo -u $HIVE_USER nohup hive --service metastore -hiveconf hive.log.file=hivemetastore.log >$HIVE_LOG_DIR/hive.out 2>$HIVE_LOG_DIR/hive.log &
}

install_hive
create_hive_log_dir
configure_hive
create_hdfs_dir
init_and_start_metastore

echo "Completed successfully: setup-hive"
