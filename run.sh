#!/bin/bash
set -euo pipefail

ansible-playbook k3s.orchestration.site -i inventory.yaml
