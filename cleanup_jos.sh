#!/usr/bin/env bash

# License: Apache-2.0

source scripts/ansible-precheck.sh
source scripts/task_log_file.sh
source scripts/parse_args.sh

flavor=""
while getopts ":f:" o; do
    case "${o}" in
        f)
            flavor=${OPTARG}
            ;;
        *)
            echo "Invalid flag"
            exit 1
            ;;
    esac
done
shift $((OPTIND-1))


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
        if [[ -f "${dir}/30_${flavor}_flavor.yml" ]]; then
            rm -f "${dir}/30_${flavor}_flavor.yml"
        fi
    done
fi

limit=""
filter="${1:-}"

if [[ "${flavor}" == central_orchestrator ]]; then
    playbook="network_edge_orchestrator_cleanup.yml"
    limit=$(get_limit "c")
else
    playbook="network_edge_cleanup.yml"
    limit=$(get_limit "${filter}")
fi

eval ansible-playbook -vv \
    "${playbook}" \
    --inventory inventory.ini "${limit}"
