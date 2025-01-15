#!/bin/bash

set -euo pipefail

source .venv/bin/activate

# KA_ANSIBLE_DIR=.venv/share/kolla-ansible/ansible/
# export ANSIBLE_ACTION_PLUGINS="$KA_ANSIBLE_DIR/action_plugins"
# export ANSIBLE_FILTER_PLUGINS="$KA_ANSIBLE_DIR/filter_plugins"
# export ANSIBLE_ROLES_PATH="$KA_ANSIBLE_DIR/roles"
# export ANSIBLE_LIBRARY="$KA_ANSIBLE_DIR/library"


declare -a POSARGS=()

while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        *)
            POSARGS+=($key)
            ;;
    esac
    shift
done


# modify positional args to pass to kolla ansible
declare -a kolla_args=()

# if we're running bootstrap_servers, we use the default python interpereter
# if we're NOT, then use python from the venv created by bootstrap_servers
if [[ ! "${POSARGS[@]}" =~ bootstrap-servers ]]; then
    kolla_args+=(--extra ansible_python_interpreter="/opt/kolla/venv/bin/python")
fi


# need to pass full path or openrc fails
kolla_args+=("${POSARGS[@]}")
kolla-ansible \
    --inventory /home/ubuntu/ka_native/site_config/all-in-one \
    --configdir /home/ubuntu/ka_native/site_config/config \
    --passwords /home/ubuntu/ka_native/site_config/passwords.yml \
    "${kolla_args[@]}"
