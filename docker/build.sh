#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")"

# start a local docker registry
docker inspect registry || docker run -d -p 5000:5000 --name registry registry:latest
[ "$(docker inspect -f '{{.State.Status}}' registry)" == "running" ] || docker start registry

# build localhost:5000/hello for arm64 and push to local registry
docker buildx build --platform linux/arm64 -t localhost:5000/hello . --push
