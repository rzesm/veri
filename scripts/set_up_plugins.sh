#!/bin/bash

sudo -v

hyprpm update
yes | hyprpm add https://github.com/sandwichfarm/hyprexpo
hyprpm enable hyprexpo