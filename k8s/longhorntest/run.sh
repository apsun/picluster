#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")"

apply() {
    kubectl apply -f pvc.yaml
    kubectl apply -f deployment.yaml
}

describe() {
    kubectl --namespace longhorn-system describe volumes.longhorn.io
    kubectl --namespace longhorn-system describe nodes.longhorn.io
    kubectl describe pods
    kubectl describe pvc
    kubectl describe pv
}

delete() {
    kubectl delete -f pvc.yaml
    kubectl delete -f deployment.yaml
}

"$@"
