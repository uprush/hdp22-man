#!/bin/bash
#
# Set up Storm
#

DEMO_HOME=`dirname $0`
DEMO_HOME=`cd $DEMO_HOME; pwd`

source $DEMO_HOME/functions.sh

STORM_CONF_DIR=/etc/storm/conf

SUBCMD=$1

function install_storm() {
  apt-get install -y storm
  mkdir /home/storm
  chown storm:storm /home/storm
  mkdir -p /etc/storm/conf
  touch $STORM_CONF_DIR/storm.yaml
}

function install_supervisor() {
  # isntall supervisord
  apt-get install -y supervisor
  if [[ "$SUBCMD" == "master" ]]; then
    cp $DEMO_HOME/conf/storm/supervisord-master.conf /etc/supervisor/conf.d/storm-master.conf
  elif [[ "$SUBCMD" == "worker" ]]; then
    cp $DEMO_HOME/conf/storm/supervisord-worker.conf /etc/supervisor/conf.d/storm-worker.conf
  else
    echo "Wrong sub command. Sub command must be 'master' or 'worker'"
    exit 1
  fi

  # Fix the error "Error: Another program is already listening on a port that one of our HTTP servers is configured to use."
  unlink /var/run//supervisor.sock
}

function configure_storm() {
  echo "Creating Storm local dir at: $STORM_LOCAL_DIR"
  mkdir -p $STORM_LOCAL_DIR
  chown -R storm:storm $STORM_LOCAL_DIR/../
  chmod -R 755 $STORM_LOCAL_DIR/../

  echo "Overwriting storm.yaml"
  MASTER_HOSTNAME=`cat $DEMO_HOME/conf/cluster/masters`
  echo "$STORM_LOCAL_DIR" | sed -e 's/\//\\\//g' > /tmp/storm_local_dir
  TMP_STORM_LOCAL_DIR=`cat /tmp/storm_local_dir`
  sed -i "s/TODO_ZOOKEEPER_SERVERS/$MASTER_HOSTNAME/g" $DEMO_HOME/conf/storm/storm.yaml
  sed -i "s/TODO_NIMBUS_HOSTNAME/$MASTER_HOSTNAME/g" $DEMO_HOME/conf/storm/storm.yaml
  sed -i "s/TODO_STORM_LOCAL_DIR/$TMP_STORM_LOCAL_DIR/g" $DEMO_HOME/conf/storm/storm.yaml
  cp $DEMO_HOME/conf/storm/storm.yaml $STORM_CONF_DIR
}

install_storm
install_supervisor
configure_storm
echo "Successfully completed: setup-storm $SUBCMD"
