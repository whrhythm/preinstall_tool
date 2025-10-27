#!/usr/bin/env bash

# License: Apache-2.0


set -eu

source scripts/ansible-precheck.sh
source scripts/task_log_file.sh
source scripts/parse_args.sh

flavor="standard"

# Remove all previous flavors
find "${PWD}/group_vars/" -type l -name "20_*_flavor.yml" -delete

if [[ -z "${flavor}" ]]; then
    echo "No flavor provided"
    echo -e "   $0 [-f <flavor>] <filter>. Available flavors: $(ls -m flavors)"
else
    flavor_path="${PWD}/flavors/${flavor}"
    if [[ ! -d "${flavor_path}" ]]; then
        echo "Flavor ${flavor} does not exist[${flavor_path}]"
        exit 1
    fi

    for f in "${flavor_path}"/*.yml
    do
        fname=$(basename "${f}" .yml)
        dir="${PWD}/group_vars/${fname}"
        if [[ ! -d "${dir}" ]]; then
            echo "${f} does not match a directory in group_vars:"
            ls "${PWD}/group_vars/"
            exit 1
        fi
        ln -sfn "${f}" "${dir}/20_${flavor}_flavor.yml"
    done
fi

playbook="joiningos_add.yml"

eval ansible-playbook -vv \
    "${playbook}" \
    --inventory inventory.ini
