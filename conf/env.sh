#!/bin/bash
# Environment variables
#

# For setup
PDSH_SUDO_USER=vagrant

# HDP settings
HDP_VERSION="2.2.0.0-2041"

# JAVA
JAVA_HOME_PATH='/usr/java/default'

## HDFS settings. See hdp_helper/scripts/directories.sh
## Recommended configuration on AWS:
##   - Multiple EBS for NN/SNN directories
##   - Multiple instance stores for DD/YARN directories
##     Number of instance stores depends on EC2 instance size
LIST_OF_NAMENODE_DIRS="/hadoop/hdfs/nn"
LIST_OF_DATA_DIRS="/hadoop/hdfs/dn"
LIST_OF_YARN_LOCAL_DIRS="/hadoop/yarn/local"
LIST_OF_YARN_LOCAL_LOG_DIRS="/var/log/hadoop-yarn"
ZOOKEEPER_DATA_DIR="/zookeeper/data"

# YARN
YARN_PID_DIR2="/var/run/hadoop-yarn"
YARN_CONF_DIR="/etc/hadoop/conf"

## HDP repository
HDP_REPO="http://public-repo-1.hortonworks.com/HDP/centos6/2.x/GA/2.2.0.0/hdp.repo"

# NTP
LOCAL_NETWORK='172.31.0.0'
NETWORK_MASK='255.255.0.0'
NTP_SERVER='TODO_MASTER_NODE_IP'

# metastore
MYSQL_ROOT_PASSWORD='rootpwd'
METASTORE_DB_NAME='hive'
METASTORE_DB_ID='hive'
METASTORE_DB_USER='hive'
METASTORE_DB_PASSWORD='hivepassword'
# replace following with RDS endpoint
METASTORE_DB_HOST='ambari1.kintoki.mt'
METASTORE_DB_PORT='3306'
METASTORE_DB_DRIVER='com.mysql.jdbc.Driver'

MYSQL_CONNECTOR_URL='TODO_URL_TO_DOWNLOAD_mysql-connector-java-5.1.33-bin.jar'

# for storm
STORM_LOCAL_DIR='/storm/local'

# Tez
TEZ_CONF_DIR='/etc/tez/conf'
TEZ_USER='tez'
TEZ_APPMASTER_RAM_MB=256
