#!/bin/bash

echo "Starting ambari1..."
vagrant up ambari1 &
sleep 1

echo "Starting master1..."
vagrant up master1 &
sleep 1

echo "Starting slave1..."
vagrant up slave1 &
sleep 1

echo "Starting slave2..."
vagrant up slave2 &
sleep 1

echo "Done"

vagrant status
