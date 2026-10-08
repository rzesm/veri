#!/usr/bin/bash

hyprctl dispatch "hl.dsp.window.close({ window = \"class:quick-terminal\" })"
pkill -x resources || resources
