#!/bin/bash

battery=$(internal/scripts/find_battery.sh)
[[ $battery != "" ]] && echo -e $battery > internal/configured/hardware/battery

gpu=$(python internal/scripts/find_gpu.py)
[[ $gpu != "" ]] && echo -e $gpu > internal/configured/hardware/gpu