#!/bin/bash
rm -v ~/.bashrc ~/.local/share/mc/bashrc ~/.tmux.conf
cp -vf bash/.bashrc ~/.bashrc
mkdir -vp ~/.githooks
cp -v git/hooks/* ~/.githooks/
cp -vf tmux/.tmux.conf ~/.tmux.conf
mkdir -vp ~/.bashrc.d
[ -d "./bash/.bashrc.d" ] && cp -v bash/.bashrc.d/*.sh ~/.bashrc.d
