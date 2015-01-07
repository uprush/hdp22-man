#!/bin/bash
#
# Start an RDS instance as the metastore database of HCatalog/Hive
#

# aws rds create-db-instance \
# --db-name $METASTORE_DB_NAME \
# --db-instance-identifier $METASTORE_DB_ID \
# --allocated-storage 5 \
# --db-instance-class db.t2.small \
# --engine MySQL \
# --master-username $METASTORE_DB_USER \
# --master-user-password $METASTORE_DB_PASSWORD


DEMO_HOME=`dirname $0`
DEMO_HOME=`cd $DEMO_HOME; pwd`

METASTORE_FQDN='ambari1.kintoki.mt'

source $DEMO_HOME/conf/env.sh

# start VM
vagrant status ambari1 | grep 'ambari1 .*running'
if [[ $? -ne 0 ]]; then
  echo "Starting metastore, FQDN: ${METASTORE_FQDN}"
  vagrant up ambari1
fi

# wait for instance to be ready
sleep 1

# Note master private FQDN
rm -f $DEMO_HOME/conf/cluster/metastore
mkdir -p $DEMO_HOME/conf/cluster


echo $METASTORE_FQDN > $DEMO_HOME/conf/cluster/metastore
echo "Metastore private FQDN: `cat $DEMO_HOME/conf/cluster/metastore`"

