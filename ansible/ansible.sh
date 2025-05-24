#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")"

# install host dependencies and ansible collections
ansible-galaxy collection install git+https://github.com/k3s-io/k3s-ansible.git
sudo pacman -S --needed python-kubernetes python-yaml python-jsonpatch  # required by kubernetes.core
ansible-galaxy collection install kubernetes.core

ansible-playbook -i inventory.yaml "${1:-ansible.yaml}" "${@:2}"
