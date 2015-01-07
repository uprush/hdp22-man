#!/bin/bash
#
# (Optional) Set up YARN job history server
#

DEMO_HOME=`dirname $0`
DEMO_HOME=`cd $DEMO_HOME; pwd`

source $DEMO_HOME/functions.sh

# set up directories on HDFS
sudo -u $HDFS_USER hdfs dfs -mkdir -p /mr-history/tmp
sudo -u $HDFS_USER hdfs dfs -chmod -R 1777 /mr-history/tmp
sudo -u $HDFS_USER hdfs dfs -mkdir -p /mr-history/done
sudo -u $HDFS_USER hdfs dfs -chmod -R 1777 /mr-history/done
sudo -u $HDFS_USER hdfs dfs -chown -R $MAPRED_USER:$HDFS_USER /mr-history

sudo -u $HDFS_USER hdfs dfs -mkdir -p /app-logs
sudo -u $HDFS_USER hdfs dfs -chmod -R 1777 /app-logs
sudo -u $HDFS_USER hdfs dfs -chown $YARN_USER /app-logs

echo "Completed successfully: setup-jobhistory"
