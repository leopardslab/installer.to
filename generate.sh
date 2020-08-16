#!/bin/bash

. ./logger.sh

X=()

for word in "$@"; do
  X+=$(dirname "$word " | cut -d "/" -f "1 2")" "
done

CHANGED=$(echo $X | tr ' ' '\n' | sort | uniq | xargs)

info "Generating for $CHANGED"
pip install toml
pip install pytablewriter
python generate.py $CHANGED
