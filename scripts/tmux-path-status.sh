#!/usr/bin/env bash

set -euo pipefail

path=${1:-}

[ -n "$path" ] || exit 0
[ -d "$path" ] || exit 0

basename "$path"
