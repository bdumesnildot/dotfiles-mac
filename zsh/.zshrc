# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ==============================================================================
#  HOMEBREW
# ==============================================================================
# Set Homebrew environment variables
eval "$(/opt/homebrew/bin/brew shellenv)"

# ==============================================================================
#  OH MY ZSH CONFIGURATION
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
# To customize prompt, run `p10k configure` or edit ~/.config/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# ==============================================================================
#  FUNCTIONS
# ==============================================================================
# Create and change directory
mkcd () {
  mkdir -p "$@" && cd "${@:$#}"
}

# ==============================================================================
#  ALIASES
# ==============================================================================
alias dotfiles="zed -n ~/.dotfiles"

# cmd aliases
alias ls='lsd'
alias ll='lsd -lh'
alias lla='lsd -lhA'
alias cat='bat'
alias grep='rg'
alias man='tldr'

alias cdp='cd ~/projects/'
alias cdpp='cd ~/projects/pragma-project'
alias cddw='cd ~/Downloads'
alias cdd='cd ~/.dotfiles'

alias tmpop='~/.config/tmux/launch/launch_popina_web.sh'
alias tmls='tmux ls'
alias tmkill='tmux kill-session'
alias tmdetach='tmux detach-session'

alias ccc='clear'

# dotfiles / stow (packages pattern: one top-level dir = one stow package)
dotstow() {
  (cd ~/.dotfiles && for pkg in */; do stow -v -t ~ "${pkg%/}"; done)
}
dotunstow() {
  (cd ~/.dotfiles && for pkg in */; do stow -D -v -t ~ "${pkg%/}"; done)
}
dotrestow() {
  (cd ~/.dotfiles && for pkg in */; do stow -R -v -t ~ "${pkg%/}"; done)
}

# git aliases
alias currentbranch="git_current_branch"
alias gploc='git pull origin $(currentbranch)'
alias gplom='git pull origin main'
alias gcm='git commit -m'

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

# popina cli aliases
alias pod='popina dev'

alias poep='popina env pull'

# zed aliases
alias z='zed'
alias zn='zed -n .'

# opencode aliases
alias oc='opencode'
alias ralph-linear='~/.dotfiles/.config/opencode/ralph/ralph-linear.sh'

# ==============================================================================
#  PATH & ENVIRONMENT SETUP
# ==============================================================================
# Editor
export EDITOR="micro"
#export EDITOR="zed --wait"

# Local binaries
export PATH="$HOME/.local/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/bdumesnildot/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Obsidian
alias obsidian='/Applications/Obsidian.app/Contents/MacOS/Obsidian'

# OrbStack (Docker Engine)
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

# deno
export PATH="/Users/bdumesnildot/.deno/bin:$PATH"

# opencode
export PATH="/Users/bdumesnildot/.opencode/bin:$PATH"

# claude code
export CLAUDE_CONFIG_DIR="$HOME/.config/claude"

# mise polyglot runtime manager (always last)
eval "$(mise activate zsh)"


# ==============================================================================
#  FZF CONFIGURATION
# ==============================================================================
# Define the default search command for FZF, explicitly excluding temporary/virtual files.
export FZF_DEFAULT_COMMAND='find . -type f -not -path "*.git/*" 2>/dev/null'
