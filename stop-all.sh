#!/bin/bash

echo "Stopping ambari1..."
vagrant halt ambari1 &
sleep 1

echo "Stopping master1..."
vagrant halt master1 &
sleep 1

echo "Stopping slave1..."
vagrant halt slave1 &
sleep 1

echo "Stopping slave2..."
vagrant halt slave2 &
sleep 1

echo "Done"

vagrant status
