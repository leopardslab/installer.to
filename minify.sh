#!/bin/bash

. ./logger.sh

X=()

for word in "$@"; do
  X+=$(dirname "$word " | cut -d "/" -f "1 2")" "
done

CHANGED=$(echo $X | tr ' ' '\n' | sort | uniq | xargs)

info "Minifying $CHANGED"
#shellspec $CHANGED

for directory in $CHANGED; do
  info "Minifying direcory is: $directory"
  for file in $directory/installer*.sh; do
    case "$file" in
      (*.min.sh) continue;;
    esac
    filename=${file##*/}
    filename=${filename%.sh}
    info "Minifying $directory/$filename.sh"
    ./minifier.sh -f="$directory/$filename.sh" > "$directory/$filename.min.sh"
  done
done
