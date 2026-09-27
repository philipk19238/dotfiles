# uv
export PATH="$HOME/.local/bin:$PATH"
export UV_CACHE_DIR="${UV_CACHE_DIR:-$HOME/.cache/uv}"
export BUN_INSTALL="${BUN_INSTALL:-$HOME/.bun}"
export BUN_INSTALL_CACHE_DIR="${BUN_INSTALL_CACHE_DIR:-$BUN_INSTALL/install/cache}"

# GitHub PAT for tools that expect GITHUB_PAT_TOKEN.
# Keep this lightweight in zshenv: only map existing token env vars.
if [[ -z "${GITHUB_PAT_TOKEN:-}" ]]; then
  if [[ -n "${GH_TOKEN:-}" ]]; then
    export GITHUB_PAT_TOKEN="$GH_TOKEN"
  elif [[ -n "${GITHUB_TOKEN:-}" ]]; then
    export GITHUB_PAT_TOKEN="$GITHUB_TOKEN"
  fi
fi
[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"
