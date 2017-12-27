#!/bin/bash
CFG=".Xresources .bashrc .vimrc"
cp -b $CFG ~/
xrdb ~/.Xresources

