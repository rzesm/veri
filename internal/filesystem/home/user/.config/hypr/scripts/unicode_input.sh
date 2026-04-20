#!/bin/bash

char=$(kitty +kitten unicode_input | tr -d '\n')
[[ -z $char ]] && exit
wl-copy $char > /dev/null 2>&1
echo -n $char | clipse -wl-store
