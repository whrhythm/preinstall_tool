#!/bin/sh
# License: Apache-2.0


set -euxo pipefail

BASE_PATH="$( cd "$(dirname "$0")" ; pwd -P )"

[ -d "${BASE_PATH}/logs" ] || mkdir "${BASE_PATH}/logs"
FILENAME=$(date +%Y-%m-%d_%H-%M-%S_ansible.log)

# Comment out below export to disable console logs saving to files.
export ANSIBLE_LOG_PATH="${BASE_PATH}/logs/${FILENAME}"
