# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh
if [[ "$OSTYPE" == "darwin"* ]]; then
  export ZSH=~/.oh-my-zsh/
fi

ZSH_THEME="alanpeabody"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Plugins
plugins=(git fzf npm vi-mode)

# Zoxide
echo 'eval "$(zoxide init zsh)"' >> ~/environment/home/.zshrc

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Import custom files from ~/environment/custom
for f in ~/environment/custom/*; do source $f; done

autoload -U promptinit
promptinit
autoload -U compinit
compinit
autoload -U bashcompinit
bashcompinit
setopt NO_BEEP
complete -C aws_completer aws

if [[ $1 == eval ]]
then
	"$@"
	set --
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


# bun completions
[ -s "/home/hking/.bun/_bun" ] && source "/home/hking/.bun/_bun"


# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
eval "$(direnv hook zsh)"


source ~/dev/.env

[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
[ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# sst
export PATH=/home/hking/.sst/bin:$PATH

# opencode
export PATH=/home/hking/.opencode/bin:$PATH

# opencode
export PATH=/Users/hking/.opencode/bin:$PATH

eval "$(zoxide init zsh)"

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
eval "$(zoxide init zsh)"
eval "$(zoxide init zsh)"
eval "$(zoxide init zsh)"
eval "$(zoxide init zsh)"
eval "$(zoxide init zsh)"
eval "$(zoxide init zsh)"
