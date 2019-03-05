#!/usr/bin/env bash

set -e
set -u
set -o pipefail

IMAGE="${1}"

docker run --rm --entrypoint=ngrok "${IMAGE}" version | grep -E '^ngrok\s+(version\s*)?[.0-9]+'
