#!/bin/bash

#declare -a X
X=()

for word in "$@"; do
#  echo $(dirname "$word")
  X+=$(dirname "$word")" "
done

CHANGED=$(echo $X | tr ' ' '\n' | sort | uniq | xargs)

shellspec $CHANGED
