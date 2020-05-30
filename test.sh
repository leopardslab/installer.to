#!/bin/bash

#declare -a X
X=()

for word in "$@"; do
#  echo $(dirname "$word")
  X+=$(dirname "$word " | cut -d "/" -f "1 2")" "
done

CHANGED=$(echo $X | tr ' ' '\n' | sort | uniq | xargs)

echo "Running tests on $CHANGED"
#shellspec $CHANGED
