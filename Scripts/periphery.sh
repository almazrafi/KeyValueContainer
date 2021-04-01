#!/bin/sh

if [[ "${SKIP_PERIPHERY}" == "YES" ]]; then
  exit 0
fi

if which periphery >/dev/null; then
  periphery scan "$@"
else
  echo "warning: Periphery does not exist, download it from https://github.com/peripheryapp/periphery"
fi
