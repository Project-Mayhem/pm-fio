#!/bin/bash

oc project meadowgate

echo "deleting statefulset"
oc delete statefulsets pm-fio-ss

#pvs=`oc get pvc | grep "pm-fio-ss-pvc*" | awk '{ print $1 }'`
# 
#while read -r line; do
#    oc delete pvc $line
#  # oc delete pv $line
#    echo "deleted PV $line"
#done <<< "$pvs"

# a better way to delete all the storage
oc delete pvc -l app=pm-fio-ss

sleep 30

oc replace secrets scp-secret -f ~/dev/meadowgate/scp-secret.yaml
if [ $? -gt 1 ] ; then
  oc create -f ~/dev/meadowgate/scp-secret.yaml
fi

oc replace configmaps pm-fio-configmap -f pm-fio-configmap.yaml
if [ $? -gt 0 ] ; then
  oc create -f pm-fio-configmap.yaml
fi

oc create -f pm-fio-statefulset.yaml

sleep 3

oc get events









