#!/bin/bash
#
#  Bootstrap a bastion instance for hadoop setup.
#

# Install dependencies
yum -y install epel-release
yum -y install pdsh

# Copy setup code from host
cd
cp -r /vagrant hadoop-demo
cd hadoop-demo
