# 🍎 macOS Dotfiles

Personal macOS configuration files managed with [GNU Stow](https://www.gnu.org/software/stow/), organized using the **packages pattern**: every top-level directory in this repo is a self-contained stow package that mirrors its target path under `$HOME`.

```
.dotfiles/
  claude/.config/claude/...      -> ~/.config/claude/...
  ghostty/.config/ghostty/...    -> ~/.config/ghostty/...
  mise/.config/mise/config.toml  -> ~/.config/mise/config.toml
  ssh/.ssh/...                   -> ~/.ssh/...
  zsh/.zshrc                     -> ~/.zshrc
  ...
  Brewfile                       (not stowed, referenced directly)
  README.md                      (not stowed)
```

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

4. Install runtime versions with mise:
   ```bash
   mise install
   ```

5. Deploy configurations (see [Commands](#commands) below):
   ```bash
   dotstow
   ```

## How It Works

Each top-level directory (`claude/`, `ghostty/`, `mise/`, `zsh/`, `ssh/`, ...) is an independent **stow package**. Its internal structure mirrors the path stow should create under `$HOME` (e.g. `mise/.config/mise/config.toml` gets symlinked to `~/.config/mise/config.toml`).

Because each package is independent:
- Adding a new tool config = adding a new top-level directory, no other file to edit
- You can stow/unstow a single package without touching the others
- `README.md` and `Brewfile` stay at the repo root and are never stowed

## Commands

Stow is run per-package (`stow -t ~ <package>`), not on the whole repo. Three shell functions defined in `zsh/.zshrc` wrap this in a loop over every top-level directory:

```bash
# Deploy (symlink) every package
dotstow

# Remove symlinks for every package
dotunstow

# Restow (unlink + relink) every package — use after editing package contents
dotrestow
```

Functions:
```bash
dotstow() {
  (cd ~/.dotfiles && for pkg in */; do stow -v -t ~ "${pkg%/}"; done)
}
dotunstow() {
  (cd ~/.dotfiles && for pkg in */; do stow -D -v -t ~ "${pkg%/}"; done)
}
dotrestow() {
  (cd ~/.dotfiles && for pkg in */; do stow -R -v -t ~ "${pkg%/}"; done)
}
```

For a single package, use plain stow directly:
```bash
stow -v -t ~ mise        # deploy just the mise package
stow -D -v -t ~ mise      # remove just the mise package
stow -R -v -t ~ mise      # restow just the mise package
stow -n -v -t ~ mise      # dry run (preview) for the mise package
```

## Adding a New Package

1. Create a new top-level directory named after the tool (e.g. `foo/`)
2. Recreate the path stow should produce under `$HOME` inside it (e.g. `foo/.config/foo/config.toml` for a config normally at `~/.config/foo/config.toml`)
3. Run `dotstow` (or `stow -v -t ~ foo` to just deploy the new package)
4. Commit changes

Changes to files are reflected immediately via symlinks — no need to re-stow after editing an already-deployed config file.

## Brewfile

`Brewfile` tracks all Homebrew formulas and casks, grouped by category, so a new machine can be provisioned with a single command.

```bash
# Install everything listed in the Brewfile
brew bundle install --file=~/.dotfiles/Brewfile

# Check what's missing/outdated without installing
brew bundle check --file=~/.dotfiles/Brewfile

# Update the Brewfile with your currently installed packages
brew bundle dump --file=~/.dotfiles/Brewfile --force
```

After running `brew bundle dump`, review the diff and manually re-categorize/clean up any new entries before committing.

## Runtime versions (mise)

[mise](https://mise.jdx.dev/) manages language runtime versions (Node, etc.) declared in `mise/.config/mise/config.toml`.

```bash
# Install all tools/versions declared in config.toml
mise install

# Show currently active tools
mise ls

# Add or update a tool version
mise use -g node@lts
```
