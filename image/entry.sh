#!/bin/bash

echo "$VARS" | base64 --decode | jq -r '.' > /bucc/state/vars.yml

/bucc/bin/bucc "$@"
