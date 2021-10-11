#!/bin/bash

kubectl get pods --field-selector=status.phase!=Running --all-namespaces |grep ImagePullBackOff |  awk '{$2=$2};1'| cut -d' ' -f1,2 > /tmp/pods

while read line; do
    ns=`echo $line |cut -d' ' -f1`
    pod=`echo $line | cut -d' ' -f2`
    echo -e "\e[34m We are going to delete in the namespace: \e[32m $ns \e[24m \e[32m$i\e[39m"
    echo -e "\e[34m The pod:  \e[32m $pod \e[24m \e[32m$i\e[39m"
    kubectl delete pod $pod -n $ns
done < /tmp/pods
