#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")"

# k3s-ansible
ansible-playbook k3s.orchestration.site -i inventory.yaml

# install packages
ansible-playbook playbooks/packages/packages.yaml -i inventory.yaml
