# ==============================================================================
#  1. POWERLEVEL10K INSTANT PROMPT
# ==============================================================================
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ==============================================================================
#  2. OH MY ZSH CONFIGURATION
# ==============================================================================
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set plugins
plugins=( git zsh-syntax-highlighting zsh-autosuggestions)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Load Powerlevel10k theme configuration
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ==============================================================================
#  3. ALIASES
# ==============================================================================
alias zshconfig="code ~/.config/zsh/zshrc"
alias ohmyzsh="code ~/.oh-my-zsh"
alias dotfiles="code ~/.dotfiles"
alias currentbranch="git branch | grep \* | cut -d ' ' -f2"

# cmd aliases
alias ls='lsd'
alias ll='lsd -lh'
alias lla='lsd -lhA'

alias cdd='cd ~/dev/'
alias cdpp='cd ~/dev/pragma-project'
alias cddw='cd ~/Downloads'
alias cdcf='cd ~/.config'

alias tmuxpop='~/.config/tmux/launch/launch_popina_web.sh'

## Fonction pour créer un dossier et y naviguer
mkcd () {
  mkdir -p "$@" && cd "${@:$#}"
}

alias ccc='clear'

# utils aliases
alias lg="lazygit"

# package manager aliases
alias b='brew'
alias buuc='brew update && brew upgrade && brew cleanup'

alias y='yarn'
alias pn='pnpm'
alias pni='pnpm install'

# project-specific aliases
alias pnd='pnpm dev --log-order=stream'

alias pnda='pnpm dev --log-order=stream --filter @pragma/admin --filter @pragma/api --filter @pragma/api-booking --filter @pragma/api-customer --filter @pragma/api-dataflow --filter @pragma/api-loyalty --filter @pragma/api-order --filter @pragma/api-pos --filter @pragma/api-sync --filter @pragma/api-webhook --filter @pragma/auth-pos --filter @pragma/auth-proxy --filter @pragma/backoffice'

alias pndf='pnpm dev --log-order=stream --filter @pragma/admin --filter @pragma/api --filter @pragma/api-pos --filter @pragma/api-sync  --filter @pragma/api-customer --filter @pragma/auth-pos --filter @pragma/auth-proxy --filter @pragma/backoffice --filter @pragma/workshop --filter @pragma/api'

# ==============================================================================
#  4. PATH & ENVIRONMENT SETUP
# ==============================================================================
# Add VsCode as editor
export EDITOR="micro"

# Homebrew (méthode officielle, déplacée depuis .zprofile)
eval "$(/opt/homebrew/bin/brew shellenv)"

# pnpm
export PNPM_HOME="/Users/bdumesnildot/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# OrbStack
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

# deno
export PATH="/Users/bdumesnildot/.deno/bin:$PATH"

# opencode
export PATH="/Users/bdumesnildot/.opencode/bin:$PATH"

# fnm node version manager (alway last)
eval "$(fnm env --use-on-cd --shell zsh)"


# ==============================================================================
#  5. FZF CONFIGURATION
# ==============================================================================
# Define the default search command for FZF, explicitly excluding OrbStack paths and other temporary/virtual files.
export FZF_DEFAULT_COMMAND='find . -type f -not -path "*/OrbStack/*" -not -path "*.git/*" 2>/dev/null'