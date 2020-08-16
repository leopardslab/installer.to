#!/bin/bash

X=()

for word in "$@"; do
  X+=$(dirname "$word " | cut -d "/" -f "1 2")" "
done

CHANGED=$(echo $X | tr ' ' '\n' | sort | uniq | xargs)

echo "Minifying $CHANGED"
#shellspec $CHANGED

for directory in $CHANGED; do
  echo "Minifying direcory is: $directory"
  for file in $directory/installer*.sh; do
    case "$file" in
      (*.min.sh) continue;;
    esac
    filename=${file##*/}
    filename=${filename%.sh}
    echo "Minifying $directory/$filename.sh"
    ./minifier.sh -f="$directory/$filename.sh" > "$directory/$filename.min.sh"
  done
done
