#!/bin/sh
# License: Apache-2.0

PYTHON3_MINIMAL_SUPPORTED_VERSION=368

if ! id -u 1>/dev/null; then
  echo "ERROR: Script requires root permissions"
  exit 1
fi

if [ "${0##*/}" = "${BASH_SOURCE[0]##*/}" ]; then
  echo "ERROR: This script cannot be executed directly"  
  exit 1
fi

# Check the value of offline_enable
TOP_PATH=$(cd "$(dirname "$0")";pwd)

if ! command -v ansible-playbook 1>/dev/null; then
  echo "ERROR: Could not find Ansible tool"
  exit 1
fi

if ! python -c 'import netaddr' 2>/dev/null; then
  echo "ERROR: Could not find netaddr"
  exit 1
fi

if ! command -v python3 1>/dev/null; then
  echo "ERROR: Could not find python3 package."
  exit 1
fi
