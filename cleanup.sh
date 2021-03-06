#!/bin/bash

if [ $# -ne 1 ]
then
  echo "Usage: $0 prefix"
  exit 1
fi

PREFIX=$1

echo "Deleting Fuel Master vm..."

master=$(virsh list --all | grep $PREFIX-fuel-master | awk '{print $2}')
if [ ! -z $master ]
then
    virsh destroy $master
    virsh undefine $master
    virsh vol-delete --pool default $PREFIX-fuel-master.qcow2
fi

echo "Deleting slaves..."

for i in $(virsh list --all | grep $PREFIX-fuel-slave | awk '{print $2}')
do
   echo $i
   virsh destroy $i
   sleep 2
   virsh undefine $i
done

for j in $(virsh vol-list --pool default | grep $PREFIX-fuel-slave | awk '{print $1}')
do
   echo $j
   virsh vol-delete --pool default $j
   sleep 2
done

