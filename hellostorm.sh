#!/bin/bash
#

DEMO_HOME=`dirname $0`
DEMO_HOME=`cd $DEMO_HOME; pwd`

source $DEMO_HOME/functions.sh

SUBCMD=$1

function package() {
  MAVEN2=`which mvn`
  if [[ "x$MAVEN2" == "x" ]]; then
      sudo apt-get install -y maven2
  fi
  cd $DEMO_HOME/storm/hellostorm
  JAVA_HOME=/usr/java/default mvn clean package
}

function run() {
  if [ ! -f $DEMO_HOME/storm/hellostorm/target/hellostorm-1.0-SNAPSHOT.jar ]; then
      echo "Pacakge not exist: $DEMO_HOME/storm/hellostorm/target/hellostorm-1.0-SNAPSHOT.jar"
      echo "Invoking 'package' sub command..."
  fi
  MASTER_HOST=`cat $DEMO_HOME/conf/cluster/masters`
  sudo -u storm storm jar -c nimbus.host=$MASTER_HOST $DEMO_HOME/storm/hellostorm/target/hellostorm-1.0-SNAPSHOT.jar com.uprush.hdemo.HelloStorm hellostorm
}

if [[ "$SUBCMD" == "package" ]]; then
  package
elif [[ "$SUBCMD" == "run" ]]; then
  run
else
  echo "Wrong sub command. Sub command must be 'package' or 'run'"
  exit 1
fi

