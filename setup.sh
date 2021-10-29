#!/bin/bash
CFG="$(pwd)/.Xresources $(pwd)/.bashrc $(pwd)/.gitconfig $(pwd)/.vimrc"

mkdir -p ~/.config/openbox/ ~/.config/lxpanel/LXDE/panels/

cp -sb $CFG ~/
cp -sb $(pwd)/gui/lxde-rc.xml ~/.config/openbox/
cp -sb $(pwd)/gui/panel ~/.config/lxpanel/LXDE/panels/
cp -sb $(pwd)/gui/autostart ~/.config/lxsession/LXDE/
xrdb ~/.Xresources
dconf load /apps/guake/ < ./gui/guake.ini

VSCODE_DIR="$HOME/.config/${VSCODE_PROFILE:-Code - OSS}/User"
mkdir -p "$VSCODE_DIR" && cp -sb "$(pwd)/vscode-config"/*.json "$VSCODE_DIR/"

