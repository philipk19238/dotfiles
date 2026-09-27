# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"

# Skip compaudit permission checks on every startup (trusted single-user machine)
ZSH_DISABLE_COMPFIX="true"
# Single stable compdump path so compinit reuses one cache instead of
# regenerating per-hostname dumps.
ZSH_COMPDUMP="$HOME/.cache/zsh/zcompdump"
[[ -d "$HOME/.cache/zsh" ]] || mkdir -p "$HOME/.cache/zsh"

# Prompt is handled by starship
ZSH_THEME=""

plugins=(
	git
	z
	zsh-autosuggestions
	zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# User configuration

# Python alias (use 3.11 for project compatibility)
alias python=python3.11
alias pip=pip3.11

eval "$(starship init zsh)"
source <(fzf --zsh)

# LM Studio CLI (lms)
export PATH="$PATH:$HOME/.lmstudio/bin"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Amp CLI
export PATH="$HOME/.amp/bin:$PATH"

export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Codex default permissions
alias codex="codex -a never -s danger-full-access"

# Claude: override the default system prompt with cwd only.
claude-lite() {
  command claude --system-prompt "cwd=\"$(pwd)\"" "$@"
}

# Kill process on a given port: portkill 3000
portkill() {
  local pid
  pid=$(lsof -ti tcp:"$1")
  if [[ -z "$pid" ]]; then
    echo "No process found on port $1"
  else
    echo "Killing PID $pid on port $1"
    kill -9 $pid
  fi
}

# GitHub MCP auth for interactive shells.
# Prefer existing env tokens; otherwise use a cached gh token (refreshed daily)
# so we don't exec `gh` (~350ms) on every shell startup.
if [[ -z "${GITHUB_PAT_TOKEN:-}" ]]; then
  if [[ -n "${GH_TOKEN:-}" ]]; then
    export GITHUB_PAT_TOKEN="$GH_TOKEN"
  elif [[ -n "${GITHUB_TOKEN:-}" ]]; then
    export GITHUB_PAT_TOKEN="$GITHUB_TOKEN"
  else
    _gh_token_cache="$HOME/.cache/zsh/gh-token"
    if [[ ! -s "$_gh_token_cache" || -n "$(find "$_gh_token_cache" -mmin +1440 2>/dev/null)" ]]; then
      command -v gh >/dev/null 2>&1 && gh auth token 2>/dev/null > "$_gh_token_cache"
    fi
    [[ -s "$_gh_token_cache" ]] && export GITHUB_PAT_TOKEN="$(<"$_gh_token_cache")"
    unset _gh_token_cache
  fi
fi

# Enable long-lived prompt cache retention.
export PI_CACHE_RETENTION="long"

eval "$(mise activate zsh)"

# Machine-local config and secrets (API keys, tokens, work helpers). Not tracked.
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
