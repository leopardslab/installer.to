#!/bin/bash

X=()

for word in "$@"; do
  X+=$(dirname "$word " | cut -d "/" -f "1 2")" "
done

CHANGED=$(echo $X | tr ' ' '\n' | sort | uniq | xargs)

echo "Running tests on $CHANGED"
shellspec $CHANGED
