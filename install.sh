#!/usr/bin/env bash
# Bootstrap: Oh My Zsh + plugins + starship/fzf/mise, then symlink dotfiles into $HOME.
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
brew install starship fzf mise

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
clone_plugin() {
  [[ -d "$ZSH_CUSTOM/plugins/$1" ]] || git clone --depth 1 "https://github.com/zsh-users/$1" "$ZSH_CUSTOM/plugins/$1"
}
clone_plugin zsh-autosuggestions
clone_plugin zsh-syntax-highlighting

link() {
  local src="$DOTFILES/$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [[ -e "$dst" && ! -L "$dst" ]]; then
    mv "$dst" "$dst.backup.$(date +%s)"
  fi
  ln -sfn "$src" "$dst"
  echo "linked $dst -> $src"
}

link zsh/.zshrc "$HOME/.zshrc"
link zsh/.zshenv "$HOME/.zshenv"
link zsh/.zprofile "$HOME/.zprofile"
link config/starship.toml "$HOME/.config/starship.toml"
link config/ghostty/config "$HOME/.config/ghostty/config"
link config/git/attributes "$HOME/.config/git/attributes"
link config/git/gitconfig "$HOME/.gitconfig"
link config/git/sweetspot "$HOME/.config/git/sweetspot"

[[ -f "$HOME/.zshrc.local" ]] || cp "$DOTFILES/zsh/.zshrc.local.example" "$HOME/.zshrc.local"
echo "Done. Put secrets in ~/.zshrc.local, then restart your shell."
