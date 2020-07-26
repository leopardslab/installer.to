#!/bin/bash

X=()

for word in "$@"; do
  X+=$(dirname "$word " | cut -d "/" -f "1 2")" "
done

CHANGED=$(echo $X | tr ' ' '\n' | sort | uniq | xargs)

echo "minifying $CHANGED"
#shellspec $CHANGED

for word in $CHANGED; do
  ./minifier.sh -f="$word/installer.sh" > "$word/installer.min.sh"
done
