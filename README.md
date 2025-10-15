# 🍎 macOS Dotfiles

Personal macOS configuration files managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Setup

1. Install Stow:
   ```bash
   brew install stow
   ```

2. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```

3. Deploy configurations:
   ```bash
   stow .
   ```

## How It Works

Stow creates symlinks from your home directory to files in this repository. This lets you keep all configurations in one place, version control them, and easily deploy on new machines.

## Commands

```bash
# Deploy all configurations
stow .

# Deploy specific directory
stow .config

# Remove all symlinks
stow -D .

# Preview changes (dry run)
stow -n .

# Adopt existing files into repo
stow --adopt .
```

## Adding Configurations

1. Add config files to the appropriate directory structure
2. Run `stow .` to create symlinks
3. Commit changes

Changes to files are reflected immediately via symlinks.
