#!/usr/bin/env bash

set -e
set -u
set -o pipefail

IMAGE="${1}"
ARCH="${2}"
TAG="${3}"

docker run --rm --platform "${ARCH}" --entrypoint=ngrok "${IMAGE}:${TAG}" version | grep -E '^ngrok\s+(version\s*)?[.0-9]+'
