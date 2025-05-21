#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")"

host=$(kubectl get nodes -o json | jq '.items[]'.metadata.name -r | shuf | head -n1).lan
port=$(kubectl get svc hello -o json | jq .spec.ports[0].nodePort)
curl "${host}:${port}"
