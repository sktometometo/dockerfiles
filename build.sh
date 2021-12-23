#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0);pwd)

echo "SCRIPT_DIR: $SCRIPT_DIR"

for name in $SCRIPT_DIR/*; do
    if [ -d $name ]; then
        imagename=$(basename $name)
        echo "Building $imagename"
        docker build -t sktometometo/ubuntu-ros:$imagename $SCRIPT_DIR/$imagename
    fi
done
