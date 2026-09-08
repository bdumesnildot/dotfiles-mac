# 🍎 macOS Dotfiles

Personal macOS configuration files managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Setup

1. Install Homebrew (if not already installed):
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```

3. Install all packages from the Brewfile:
   ```bash
   brew bundle install --file=Brewfile
   ```

4. Deploy configurations:
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

## Brewfile

`Brewfile` tracks all Homebrew formulas and casks, grouped by category, so a new machine can be provisioned with a single command.

```bash
# Install everything listed in the Brewfile
brew bundle install --file=Brewfile

# Check what's missing/outdated without installing
brew bundle check --file=Brewfile

# Update the Brewfile with your currently installed packages
brew bundle dump --file=Brewfile --force
```

After running `brew bundle dump`, review the diff and manually re-categorize/clean up any new entries before committing.
