#!/bin/bash
CFG=".Xresources .bashrc .gitconfig .vimrc"

mkdir -p ~/.config/openbox/ ~/.config/lxpanel/LXDE/panels/

cp -sb $CFG ~/
cp -sb ./gui/lxde-rc.xml ~/.config/openbox/
cp -sb ./gui/panel ~/.config/lxpanel/LXDE/panels/
cp -sb ./gui/autostart ~/.config/lxsession/LXDE/
xrdb ~/.Xresources
dconf load /apps/guake/ < ./gui/guake.ini

VSCODE_DIR="$HOME/.config/${VSCODE_PROFILE:-Code - OSS}/User"
mkdir -p "$VSCODE_DIR" && cp -sb "$(pwd)/vscode-config"/*.json "$VSCODE_DIR/"

