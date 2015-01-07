#!/bin/bash
#
# Set up metastore
#
DEMO_HOME=`dirname $0`
DEMO_HOME=`cd $DEMO_HOME; pwd`

source $DEMO_HOME/functions.sh

function install_mysql() {
  yum -y install mysql-server
  chkconfig mysqld on
  /etc/init.d/mysqld start
}

function configure_mysql() {
  mysqladmin -u root password $MYSQL_ROOT_PASSWORD
  mysqladmin -u root 2>&1 >/dev/null
}

function create_hive_user() {
  cat <<EOF > /tmp/create-hive-user.sql
CREATE USER 'hive'@'localhost' IDENTIFIED BY 'hivepassword';
GRANT ALL PRIVILEGES ON *.* TO 'hive'@'localhost';
CREATE USER 'hive'@'%' IDENTIFIED BY 'hivepassword';
GRANT ALL PRIVILEGES ON *.* TO 'hive'@'%';
FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'hive'@'localhost' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'hive'@'%' WITH GRANT OPTION;
EOF

  mysql -u root -p$MYSQL_ROOT_PASSWORD < /tmp/create-hive-user.sql
}

install_mysql
configure_mysql
create_hive_user

echo "Completed successfully: setup-metastore"
