#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")"

# build and push image
../../docker/build.sh

# delete existing service
kubectl get svc hello && kubectl delete svc hello && kubectl wait --for delete svc hello

# delete existing deployment
kubectl get deploy hello && kubectl delete deploy hello && kubectl wait --for delete deploy hello

# create deployment
kubectl create deploy hello --image sachiko.lan/hello --replicas 100 && kubectl wait --for create deploy hello

# create service
kubectl create svc nodeport hello --tcp 80:80 && kubectl wait --for create svc hello

# show service info
kubectl get svc hello

# show pod and node info
kubectl get pod -o wide
