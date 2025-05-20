#!/bin/bash
set -euo pipefail

ansible-playbook k3s.orchestration.site -i inventory.yaml
ansible-playbook playbooks/packages/packages.yaml -i inventory.yaml
