# ~/.bashrc or ~/.bash_profile should point here

shopt -s checkwinsize
shopt -s histappend
shopt -s cmdhist
shopt -s dotglob
shopt -s autocd
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
export HISTIGNORE="&:ls:ls *:[bf]g:f:vim:cd *:exit"

set -o noclobber
set -o vi

alias ls='ls --color'

alias ls='ls -G'
alias l='ls -CF'
alias ll='ls -ahlF'
alias la='ls -A'

alias grep='grep --color'
alias f='fg'
alias one='git log --oneline --all --graph'

alias fetch='deno run --allow-net'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[ -r "$HOME/bash_prompt" ] && . "$HOME/bash_prompt"
[ -r "$HOME/git-completion.bash" ] && . "$HOME/git-completion.bash"
[ -r "$HOME/npm-completion.bash" ] && . "$HOME/npm-completion.bash"
[ -r "$HOME/deno.bash" ] && . "$HOME/deno.bash"
[ -r "$HOME/alacritty.bash" ] && . "$HOME/alacritty.bash"

# deno
export DENO_INSTALL="${HOME}/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

export PATH="${HOME}/.ngrok:$PATH"
export PATH="${HOME}/terraform:$PATH"
export PATH="${HOME}/rg:$PATH"

export PATH="/usr/local/bin:$PATH"

export ANDROID_HOME="${HOME}/Library/Android/sdk"
export ANDROID_SDK_ROOT="${HOME}/Library/Android/sdk"
export ANDROID_AVD_HOME="${HOME}/.Android/avd"
export PATH="$ANDROID_HOME:$ANDROID_AVD_HOME:$PATH"

export PATH="/usr/local/opt/postgresql@13/bin:$PATH"

export EDITOR="vim"

complete -C /usr/local/bin/aws_completer aws

complete -C "${HOME}/terraform/terraform" terraform

[ -r "/usr/local/etc/profile.d/bash_completion.sh" ] && . "/usr/local/etc/profile.d/bash_completion.sh"

