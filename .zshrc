ZSH_THEME="gozilla"

export ZSH="$HOME/.oh-my-zsh"

# Plugins
plugins=(zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

# Load aliases
source ~/.zsh_aliases

path+=('/home/nei/.local/bin')
export PATH
