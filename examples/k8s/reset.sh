#!/bin/bash

oc project meadowgate

oc delete pvc pm-fio-pvc-ceph
oc create -f pm-fio-pvc-ceph.yaml

oc replace secrets scp-secret -f ~/dev/meadowgate/scp-secret.yaml
if [ $? -gt 1 ] ; then
  oc create -f ~/dev/meadowgate/scp-secret.yaml
fi

oc replace configmaps pm-fio-configmap -f pm-fio-configmap.yaml
if [ $? -gt 0 ] ; then
  oc create -f pm-fio-configmap.yaml
fi

oc delete deployments pm-fio-deployment

oc create -f pm-fio-deployment.yaml

sleep 3

oc get events

POD_NAME=`oc get pods | grep "pm-fio-deployment*" | awk '{ print $1 }'`
echo "Pod name: $POD_NAME"

oc get pods $POD_NAME

sleep 2
  
oc describe pods $POD_NAME
echo "Exit code $?"

oc logs -f $POD_NAME

  sleep 2
  
oc logs -f $POD_NAME


oc exec -it $POD_NAME /bin/bash








