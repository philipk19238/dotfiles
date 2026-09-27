# dotfiles

My macOS shell setup: zsh + [Oh My Zsh](https://ohmyz.sh) with a [starship](https://starship.rs) prompt, in [Ghostty](https://ghostty.org).

- **Oh My Zsh plugins:** `git`, `z`, [`zsh-autosuggestions`](https://github.com/zsh-users/zsh-autosuggestions), [`zsh-syntax-highlighting`](https://github.com/zsh-users/zsh-syntax-highlighting)
- **Tools:** starship, fzf, [mise](https://mise.jdx.dev), bun, uv, OrbStack
- **Ghostty:** Vesper theme, GeistMono Nerd Font (`brew install --cask font-geist-mono-nerd-font`), `cmd+d` splits, global quick terminal on ``cmd+` ``, Shift+Enter newline for Claude Code
- **Git:** auto-setup remotes on push, SSH for GitHub, [mergiraf](https://mergiraf.org) structural merges

## Install

```sh
git clone https://github.com/philipk19238/dotfiles ~/dotfiles
~/dotfiles/install.sh
```

Existing files are moved to `*.backup.<timestamp>` before being symlinked.

## Secrets

API keys and machine-specific config go in `~/.zshrc.local` (sourced last, gitignored).
See `zsh/.zshrc.local.example`.
