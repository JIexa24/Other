git config --$1 alias.co checkout
git config --$1 alias.cm "commit -m"
git config --$1 alias.st status
git config --$1 alias.br branch
git config --$1 alias.hist "log --pretty=format:'%C(cyan)%h%Creset %ad | %s%C(cyan)%d%Creset [%C(bold blue)%an|%ae%Creset] %C(green)(%cr)%Creset' --graph --date=local --all"
git config --$1 alias.ps push
git config --$1 alias.pl pull
git config --$1 alias.ft fetch
git config --$1 alias.mg merge
git config --$1 alias.cf config
git config --$1 alias.ad add
git config --$1 alias.cl clone

#git config --$1 credential.helper cache --timeout 60000
git config --$1 credential.helper store
