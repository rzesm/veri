#!/bin/bash

sudo -v

hyprpm update
if ! hyprpm list | grep -q hyprexpo; then
    yes | hyprpm add https://github.com/sandwichfarm/hyprexpo
    hyprpm enable hyprexpo
fi