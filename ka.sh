#!/bin/bash

set -euo pipefail


declare -a POSARGS=()

while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -s|--site)
            KA_SITE_ARG="$(realpath "$2")"
            shift # Past arg
            ;;
        -i|--inventory)
            KA_INVENTORY_ARG="$(realpath "$2")"
            shift # Past arg
            ;;
        *)
            POSARGS+=($key)
            ;;
    esac
    shift
done

# if args are passed, override env vars
KA_SITE=${KA_SITE_ARG:-$KA_SITE}
KA_INVENTORY=${KA_INVENTORY_ARG:-$KA_INVENTORY}


# modify positional args to pass to kolla ansible
declare -a kolla_args=()

# if we're running bootstrap_servers, we use the default python interpereter
# if we're NOT, then use python from the venv created by bootstrap_servers
if [[ "${POSARGS[@]}" =~ bootstrap-servers ]]; then
    kolla_args+=(--extra ansible_python_interpreter="python")
fi

# disable initial host key checking
export ANSIBLE_HOST_KEY_CHECKING=false

# need to pass full path or openrc fails
kolla_args+=("${POSARGS[@]}")
kolla-ansible \
    --configdir "${KA_SITE}" \
    --inventory "${KA_INVENTORY}" \
    --passwords "${KA_SITE}/passwords.yml" \
    "${kolla_args[@]}"
