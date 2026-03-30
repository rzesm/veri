#!/bin/bash

[[ ! -e ~/.config/veri ]] && exit 1
[[ ! -f ~/.config/veri/flags.conf ]] && exit 2
[[ ! -e ~/.config/veri/ignore ]] && exit 3
[[ ! -f ~/.config/veri/ignore/files.conf ]] && exit 4
[[ ! -f ~/.config/veri/ignore/gsettings.conf ]] && exit 5
[[ ! -f ~/.config/veri/ignore/packages.conf ]] && exit 6
[[ ! -f ~/.config/veri/ignore/services.conf ]] && exit 7

exit 0