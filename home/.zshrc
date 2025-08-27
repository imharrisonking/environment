# Oh-My-Zsh configuration
if [[ "$OSTYPE" == "darwin"* ]]; then
  export ZSH=~/.oh-my-zsh
else
  # Linux typically uses system-wide installation
  if [ -d "/usr/share/oh-my-zsh" ]; then
    export ZSH=/usr/share/oh-my-zsh
  else
    export ZSH=~/.oh-my-zsh
  fi
fi

# Theme configuration
ZSH_THEME="alanpeabody"

# Oh-My-Zsh settings
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

# Load Oh-My-Zsh
source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Custom configurations
for f in ~/environment/custom/*; do source $f; done

# Shell autoloads and completions
autoload -U promptinit
promptinit
autoload -U compinit
compinit
autoload -U bashcompinit
bashcompinit
setopt NO_BEEP
complete -C aws_completer aws

# Eval command support
if [[ $1 == eval ]]
then
	"$@"
	set --
fi

# Development environment
source ~/dev/.env

# FZF configuration
if [[ "$OSTYPE" == "linux"* ]]; then
  [ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
  [ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh
fi
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Development tools PATH
export PATH=$HOME/.sst/bin:$PATH
export PATH=$HOME/.opencode/bin:$PATH

# Zoxide initialization
eval "$(zoxide init zsh)"

# Corporate certificates
if [ -f "$HOME/.certs/combined-corporate-certs.pem" ]; then
  export NODE_EXTRA_CA_CERTS="$HOME/.certs/combined-corporate-certs.pem"
fi

# NVM configuration
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Conda/Anaconda configuration
CONDA_PATHS=("/opt/anaconda3" "/opt/miniconda3" "$HOME/anaconda3" "$HOME/miniconda3" "/usr/local/anaconda3")
for conda_path in "${CONDA_PATHS[@]}"; do
    if [ -f "$conda_path/bin/conda" ]; then
        __conda_setup="$("$conda_path/bin/conda" 'shell.zsh' 'hook' 2> /dev/null)"
        if [ $? -eq 0 ]; then
            eval "$__conda_setup"
        else
            if [ -f "$conda_path/etc/profile.d/conda.sh" ]; then
                . "$conda_path/etc/profile.d/conda.sh"
            else
                export PATH="$conda_path/bin:$PATH"
            fi
        fi
        unset __conda_setup
        break
    fi
done

alias claude="/Users/harrisonking/.claude/local/claude"
