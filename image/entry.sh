#!/bin/bash

echo "$VARS" > /bucc/vars.yml

/bucc/bin/bucc "$@"
