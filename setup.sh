#!/bin/bash
CFG=".Xresources .bashrc .gitconfig .vimrc"
cp -sb $CFG ~/
xrdb ~/.Xresources
dconf load /apps/guake/ < ./guake.ini

VSCODE_DIR="$HOME/.config/${VSCODE_PROFILE:-Code - OSS}/User"
mkdir -p "$VSCODE_DIR" && cp -sb "$(pwd)/vscode-config"/*.json "$VSCODE_DIR/"

