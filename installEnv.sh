#!/bin/bash
rm -vf ~/.bashrc ~/.local/share/mc/bashrc ~/.tmux.conf
cp -vf bash/.bashrc ~/.bashrc
cp -vf bash/.bash_profile ~/.bash_profile
cp -vf bash/.profile ~/.profile
mkdir -vp ~/.githooks
cp -vf git/hooks/* ~/.githooks/
cp -vf tmux/.tmux.conf ~/.tmux.conf
mkdir -vp ~/.bashrc.d
[ -d "./bash/.bashrc.d" ] && cp -vf bash/.bashrc.d/*.sh ~/.bashrc.d
./git/gitalias.sh
chmod -v 700 ~
# deprecated
rm -f ~/.bashrc.d/{ansible,autoenv,aws,go,nvm}.sh
