#!/usr/bin/env bash

set -euo pipefail

path=${1:-}

[ -n "$path" ] || exit 0
[ -d "$path" ] || exit 0

cd "$path"
status_output=$(git status --porcelain=2 --branch 2>/dev/null) || exit 0

branch=''
dirty=''
oid=''

while IFS= read -r line; do
  case "$line" in
    '# branch.head '*)
      branch=${line#'# branch.head '}
      ;;
    '# branch.oid '*)
      oid=${line#'# branch.oid '}
      ;;
    '1 '*|'2 '*|'u '*|'? '*|'! '*)
      dirty='*'
      break
      ;;
    '# '|'')
      ;;
  esac
done <<EOF
$status_output
EOF

if [ -z "$branch" ] || [ "$branch" = '(detached)' ]; then
  if [ -n "$oid" ]; then
    branch="detached@${oid:0:7}"
  else
    branch='detached@unknown'
  fi
fi

if [ -n "$dirty" ]; then
  printf '%s %s' "$branch" "$dirty"
else
  printf '%s' "$branch"
fi
