#!/bin/bash

set -euo pipefail

source .venv/bin/activate


declare -a POSARGS=()

while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -s|--site)
            CC_ANSIBLE_SITE="$(realpath "$2")"
            shift # Past arg
            ;;
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
if [[ "${POSARGS[@]}" =~ bootstrap-servers ]]; then
    kolla_args+=(--extra ansible_python_interpreter="python3")
fi

# need to pass full path or openrc fails
kolla_args+=("${POSARGS[@]}")
kolla-ansible \
    --configdir "${CC_ANSIBLE_SITE}" \
    --inventory "${CC_ANSIBLE_SITE}/all-in-one" \
    --passwords "${CC_ANSIBLE_SITE}/passwords.yml" \
    "${kolla_args[@]}"
