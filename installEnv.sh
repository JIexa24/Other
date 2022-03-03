#!/bin/bash
rm -v ~/.bashrc ~/.local/share/mc/bashrc ~/.tmux.conf
cp -vf bash/.bashrc ~/.bashrc
mkdir -vp ~/.local/share/mc/
mkdir -vp ~/.githooks
cp -v git/hooks/* ~/.githooks/
cp -vf bash/bashrc_mc ~/.local/share/mc/bashrc
cp -vf tmux/.tmux.conf ~/.tmux.conf
mkdir -vp ~/.bashrc.d

