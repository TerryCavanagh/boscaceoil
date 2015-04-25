#!/bin/bash

set -e # Terminate this script as soon as any command fails

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $SCRIPT_DIR

git rebase master

amxmlc -swf-version 20 -default-frame-rate 60 -default-size 768 480 -library-path+=libs/sion065.swc -source-path+=src -default-background-color 0x000000 -warnings -strict src/Main.as -o BoscaCeoil.swf -define=CONFIG::desktop,false

echo "Build successful."
