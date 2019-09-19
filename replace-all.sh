#!/usr/bin/env sh

set -eu

file="${1:-}"
if [ -z "$file" ];then
  echo "Error: specify target \$file" 1>&2
  exit 1
elif [ ! -f "$file" ]; then
  echo "Error: $file is not found" 1>&2
  exit 1
fi
shift

replace_all() {
  while [ $# -ge 0 ]; do
    if [ "${1:-}" = "" ]; then
      break
    fi

    from=$(echo "$1" | cut -d: -f1)
    to=$(echo "$1" | cut -d: -f2)

    if [ -z "$to" ]; then
      echo "Error: \$to value is required" 1>&2
      exit 1
    fi

    if command -v gsed 1>/dev/null; then
      gsed -i s/"$from"/"$to"/g "$file"
    else
      sed -i s/"$from"/"$to"/g "$file"
    fi

    shift
  done
}

replace_all "$@"
