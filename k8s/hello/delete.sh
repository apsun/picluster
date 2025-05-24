#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")"

# delete existing service
kubectl get svc hello && kubectl delete svc hello && kubectl wait --for delete svc hello

# delete existing deployment
kubectl get deploy hello && kubectl delete deploy hello && kubectl wait --for delete deploy hello
