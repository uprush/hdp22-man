HDP Manual Install Scripts
==========================

This is to demostrate how to install the hadoop eco-system on EC2.

Pre-requisites
--------------
* More than 8GB RAM avaiable on the laptop for HDP vitual machines
* Vagrant
* VirtualBox


Demostrations
-------------

# Prepare
Check out the code, start the VMs

    $ git clone
    $ cd hdp22-man
    $ ./hdemo -c start-client
    $ ./hdemo -c start-master-instances
    $ ./hdemo -c start-slave-instances
    $ ./hdemo -c start-metastore

SSH in to the client VM, copy the code from host computer.

    $ vagrant ssh ambari1
    $ /vagrant/bootstrap-bastion.sh

# Run the setup and demostration Commands from client VM

    Usage: ./hdemo [-c command] [-s subcommand] [-e command]

    -c command [-s subcommand]: run command on specific nodes
    Supported commands

      start-master-instances: start EC2 instances for hadoop masters
      start-slave-instances: start EC2 instances for hadoop slaves
      start-metastore: start RDS instance for HCatalog/Hive metastore
      start-client: start client instance
      check-reachability: check reachability for all nodes
      pre-setup: prepare for hadoop setup, runs on all nodes

      setup-masters: set up hadoop masters
      setup-slaves: set up hadoop slaves
      setup-metastore: set up metastore for HCatalog/Hive metastore
      setup-client: set up client instance
      setup-yarn: set up YARN
      setup-jobhistory: set up YARN job history server
      setup-hive: set up Hive and HCatalog
      setup-tez: set up Tez
      setup-zookeeper: set up Zookeeper
      setup-storm-master: set up Storm master
      setup-storm-worker: set up Storm worker

      namenode: format / start / stop namenode
      datanode: start / stop datanode
      yarn-rm: start / stop YARN resource manager
      yarn-nm: start / stop YARN node manager
      jobhistory: start / stop YARN job history
      hive-server: start / stop Hive server2
      zookeeper: start / stop Zookeeper
      storm-master: start / stop Storm master
      storm-worker: start / stop Storm worker

      tweets: Hive example to copy / create / load / query tweets table
      hellostorm: a simple Strom demo, supported subcommands: package / run

    -e command: run adhoc command on all nodes


# Step by Step Demostration Manual
All the following operations are done on the bastion server.

    # Edit environment variables in conf/env.sh
    $ vi conf/env.sh

    # Set up Hadoop core
    $ ./hdemo -c check_reachabilities
    $ ./hdemo -c pre-setup
    $ ./hdemo -c setup-masters
    $ ./hdemo -c setup-slaves

    # Start HDFS and YARN
    $ ./hdemo -c namenode -s format
    $ ./hdemo -c namenode -s start
    $ ./hdemo -c datanode -s start

    $ ./hdemo -c setup-yarn
    $ ./hdemo -c yarn_rm -s start
    $ ./hdemo -c yarn_nm -s start

    # Set up Tez
    $ ./hdemo -c setup-tez

    # (Optional, not well tested) Set up and start YARN job history server
    $ ./hdemo -c setup-jobhistory
    $ ./hdemo -c jobhistory -s start

    # Set up Hive
    $ ./hdemo -c setup-hive

    # (Optional, WIP) Start Hiveserver2
    $ ./hdemo -c hive_server -s start

    # Run a simple demo to copy JSON tweets data to HDFS, create Hive table and load tweets data into the table,
    # and query the data in Hive.
    $ ./hdemo -c tweets -s copy
    $ ./hdemo -c tweets -s create
    $ ./hdemo -c tweets -s load
    $ ./hdemo -c tweets -s query

Enjoy Hadoop!
