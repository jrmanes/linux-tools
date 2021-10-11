#!/bin/bash
clear

PROM_DEST_FOLDER=/tmp/prometheus-operator/
git clone https://github.com/prometheus-operator/kube-prometheus.git $PROM_DEST_FOLDER

# Create the namespace and CRDs, and then wait for them to be availble before creating the remaining resources
kubectl create -f $PROM_DEST_FOLDER/manifests/setup/

echo "Waiting to get all the services ready..."
sleep 3
until kubectl get servicemonitors --all-namespaces ; do date; sleep 1; echo ""; done

kubectl create -f $PROM_DEST_FOLDER/manifests/

