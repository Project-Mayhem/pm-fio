#!/bin/bash

oc project meadowgate

echo "deleting statefulset"
oc delete statefulsets pm-fio-ss

pvs=`oc get pvc | grep "pm-fio-ss-pvc*" | awk '{ print $1 }'`

while read -r line; do
    oc delete pvc $line
    echo "deleted PV $line"
done <<< "$pvs"

sleep 5

oc get pvc