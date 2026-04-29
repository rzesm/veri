#!/bin/sh

yad --entry \
    --title="Sudo Authentication" \
    --image="dialog-password" \
    --button="Ok:0" \
    --button="Cancel:1" \
    --text="Password for $USER:" \
    --hide-text \
    --center \
    --on-top \
    --width=350 \
    --fixed
