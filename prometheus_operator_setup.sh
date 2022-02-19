#!/bin/zsh

###############################################
#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

###############################################

echo -e "\n${yellowColour}[INFO]${endColour} ${blueColour}Downloading the project...${endColour}"

git clone https://github.com/prometheus-operator/kube-prometheus.git

echo -e "\n${yellowColour}[INFO]${endColour} ${blueColour}Creating the resources... ${endColour}"
# Create the namespace and CRDs, and then wait for them to be availble before creating the remaining resources
kubectl create -f kube-prometheus/manifests/setup


echo -e "\n${yellowColour}[INFO]${endColour} ${blueColour}Waiting to get all the services ready... ${endColour}"
sleep 3
until kubectl get servicemonitors --all-namespaces ; do date; sleep 1; echo ""; done

echo -e "\n${yellowColour}[INFO]${endColour} ${blueColour}Create manifests resources... ${endColour}"
kubectl create -f kube-prometheus/manifests/

sleep 10

echo -e "\n${yellowColour}[INFO]${endColour} ${blueColour} Modify permissiosn for cluster role in order to allow get objects from all namespace...${endColour}"
kubectl delete clusterrole prometheus-k8s

sleep 3

echo -e "\n${yellowColour}[INFO]${endColour} ${blueColour}Fix issue to being able to get info from all namespaces... ${endColour}"
# Create the cluster role
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    app.kubernetes.io/component: prometheus
    app.kubernetes.io/name: prometheus
    app.kubernetes.io/part-of: kube-prometheus
    app.kubernetes.io/version: 2.30.2
  name: prometheus-k8s
rules:
- apiGroups:
  - ""
  resources:
  - nodes/metrics
  - namespaces
  - services
  - endpoints
  - pods
  verbs: ["*"]
- nonResourceURLs:
  - /metrics
  verbs: ["*"]
EOF
