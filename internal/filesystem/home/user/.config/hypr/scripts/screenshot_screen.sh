#!/bin/bash
exec hyprshot -m output -m active -s & sleep 0.2 && notify-send "Image saved"
