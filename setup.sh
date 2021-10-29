#!/bin/bash
CFG=".Xresources .bashrc .gitconfig .vimrc"
cp -sb $CFG ~/
cp -sb ./gui/lxde-rc.xml ~/.config/openbox/
cp -b ./gui/panel ~/.config/lxpanel/LXDE/panels/
xrdb ~/.Xresources
dconf load /apps/guake/ < ./gui/guake.ini

VSCODE_DIR="$HOME/.config/${VSCODE_PROFILE:-Code - OSS}/User"
mkdir -p "$VSCODE_DIR" && cp -sb "$(pwd)/vscode-config"/*.json "$VSCODE_DIR/"

