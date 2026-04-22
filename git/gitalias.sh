git config set --global alias.co checkout
git config set --global alias.cm "commit -m"
git config set --global alias.cs "commit -S --signoff"
git config set --global alias.csm "commit -S --signoff -m"
git config set --global alias.st status
git config set --global alias.br branch
git config set --global alias.hist "log --pretty=format:'%C(cyan)%h%Creset %ad | %s%C(cyan)%d%Creset [%C(bold blue)%an|%ae%Creset] %C(green)(%cr)%Creset [%C(cyan)%G?%Creset] %C(cyan)%GS%Creset' --graph --date=local --all"
git config set --global alias.ps push
git config set --global alias.pl pull
git config set --global alias.ft fetch
git config set --global alias.mg merge
git config set --global alias.mgs "merge -S --signoff"
git config set --global alias.tgs '!f() { git tag --sign -am "${1}" "${1}"; }; f'
git config set --global alias.cf config
git config set --global alias.ad add
git config set --global alias.cl clone

git config set --global push.autoSetupRemote true

# Credential helper setup
# git config --global credential.helper cache --timeout 60000
git config set --global credential.helper store

# Хуки
# git config --global core.hooksPath ~/.githooks
git config set --global hook."conventional-commit-msg".enabled true
git config set --global hook."conventional-commit-msg".event "commit-msg"
git config set --global hook."conventional-commit-msg".command "~/.githooks/conventional-commit"
git config set --global hook."pre-commit".enabled true
git config set --global hook."pre-commit".event "pre-commit"
git config set --global hook."pre-commit".command "~/.githooks/pre-commit-app"

# Символы конца строки
git config set --global core.eol lf
git config set --global core.autocrlf false

# Подпись коммитов
# git config --global gpg.format ssh
git config --global commit.gpgsign true
# gpg --full-generate-key --expert

#[user]
#        email =
#        name =
#        signingkey = key-id

# git config --global user.signingkey ~/.ssh/keys/github-self.key

# Для подписи через ssh ключи
git config set --global gpg.ssh.allowedSignersFile "${HOME}/ssh/allowed_signers"

