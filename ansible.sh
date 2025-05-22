#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")"

# install host dependencies and ansible collections
ansible-galaxy collection install git+https://github.com/k3s-io/k3s-ansible.git
sudo pacman -S --needed python-kubernetes python-yaml python-jsonpatch  # required by kubernetes.core
ansible-galaxy collection install kubernetes.core

# configure nvme
ansible-playbook playbooks/nvme/nvme.yaml -i inventory.yaml

# install packages
ansible-playbook playbooks/packages/packages.yaml -i inventory.yaml

# install k3s
ansible-playbook k3s.orchestration.site -i inventory.yaml

# install longhorn
ansible-playbook playbooks/longhorn/longhorn.yaml -i inventory.yaml
