git config --global alias.co checkout
git config --global alias.cm "commit -m"
git config --global alias.st status
git config --global alias.br branch
git config --global alias.hist "log --pretty=format:'%C(cyan)%h%Creset %ad | %s%C(cyan)%d%Creset [%C(bold blue)%an|%ae%Creset] <%C(bold blue)%G?%Creset> %C(green)(%cr)%Creset' --graph --date=local --all"
git config --global alias.ps push
git config --global alias.pl pull
git config --global alias.ft fetch
git config --global alias.mg merge
git config --global alias.cf config
git config --global alias.ad add
git config --global alias.cl clone

#git config --global credential.helper cache --timeout 60000
git config --global credential.helper store

git config --global core.hooksPath ~/.githooks

git config --global core.eol lf
git config --global core.autocrlf false

