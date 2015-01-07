#!/bin/bash

vagrant up ambari1 &
sleep 1

vagrant up master1 &
sleep 1

vagrant up slave1 &
sleep 1

vagrant up slave2

vagrant status
