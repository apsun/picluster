#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")"

# start a local docker registry
docker inspect registry || docker run -d -p 5000:5000 --name registry registry:latest
[ "$(docker inspect -f '{{.State.Status}}' registry)" == "running" ] || docker start registry

# build localhost:5000/hello for arm64 and push to local registry
docker buildx build --platform linux/arm64 -t localhost:5000/hello docker/ --push

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
