#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")"

# stop registry on host
docker inspect registry && docker stop registry

# clean containers and images
docker system prune -af --volumes
