#!/bin/bash
CFG=".Xresources .bashrc .gitconfig .vimrc"
cp -b $CFG ~/
xrdb ~/.Xresources

