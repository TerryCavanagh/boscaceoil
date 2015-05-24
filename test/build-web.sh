#!/bin/sh

amxmlc -swf-version 28 -default-frame-rate 60 -default-size 768 560 -library-path+=lib/sion065.swc -source-path+=src -default-background-color 0x000000 -warnings -strict src/Main.as -o BoscaCeoil.swf -define+=CONFIG::desktop,false -define+=CONFIG::web,true
