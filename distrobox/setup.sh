#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────────────────────
# setup.sh — Bootstrap Neovim inside a distrobox container
#
# Usage:
#   # From the repo root (inside or outside the distrobox):
#   ./distrobox/setup.sh
#
# What it does:
#   1. Symlinks the nvim config from this repo to ~/.config/nvim
#   2. Installs Rust toolchain via rustup (if not present)
#   3. Prints instructions for API key setup (Copilot, Claude Code)
# ──────────────────────────────────────────────────────────────────────────────
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
NVIM_CONFIG_SRC="$REPO_ROOT/home/base/tui/editors/neovim/nvim"
NVIM_CONFIG_DST="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"

echo "══════════════════════════════════════════════════════════════"
echo " Neovim Distrobox Setup"
echo "══════════════════════════════════════════════════════════════"

# ── 1. Symlink Neovim config ─────────────────────────────────────────────────
echo ""
echo "→ Linking Neovim config..."
if [ -e "$NVIM_CONFIG_DST" ] || [ -L "$NVIM_CONFIG_DST" ]; then
  echo "  Existing config found at $NVIM_CONFIG_DST"
  echo "  Backing up to ${NVIM_CONFIG_DST}.bak.$(date +%s)"
  mv "$NVIM_CONFIG_DST" "${NVIM_CONFIG_DST}.bak.$(date +%s)"
fi
mkdir -p "$(dirname "$NVIM_CONFIG_DST")"
ln -sfn "$NVIM_CONFIG_SRC" "$NVIM_CONFIG_DST"
echo "  ✓ Linked $NVIM_CONFIG_DST → $NVIM_CONFIG_SRC"

# ── 2. Rust toolchain ────────────────────────────────────────────────────────
echo ""
echo "→ Checking Rust toolchain..."
if command -v rustc &>/dev/null; then
  echo "  ✓ Rust already installed: $(rustc --version)"
else
  echo "  Installing Rust via rustup..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable
  # shellcheck source=/dev/null
  source "$HOME/.cargo/env"
  echo "  ✓ Rust installed: $(rustc --version)"
fi

# Ensure rust-analyzer is available
if ! command -v rust-analyzer &>/dev/null; then
  rustup component add rust-analyzer || echo "  ⚠ Failed to install rust-analyzer — install manually with: rustup component add rust-analyzer"
fi

# ── 3. Go tools (optional) ──────────────────────────────────────────────────
echo ""
echo "→ Checking Go tools..."
if command -v go &>/dev/null; then
  echo "  ✓ Go available: $(go version)"
  # Install gopls if not present
  if ! command -v gopls &>/dev/null; then
    echo "  Installing gopls..."
    go install golang.org/x/tools/gopls@latest
  fi
else
  echo "  ⚠ Go not found — Go LSP will not be available"
fi

# ── 4. First Neovim launch info ─────────────────────────────────────────────
echo ""
echo "→ Neovim plugin bootstrap..."
echo "  On first launch, Lazy.nvim will automatically install all plugins."
echo "  Run:  nvim"
echo ""

# ── 5. API keys & authentication ────────────────────────────────────────────
echo "══════════════════════════════════════════════════════════════"
echo " Setup Complete! Next steps:"
echo "══════════════════════════════════════════════════════════════"
echo ""
echo "  1. GitHub Copilot:"
echo "     Open Neovim and run  :Copilot auth"
echo "     Follow the browser flow to authenticate."
echo ""
echo "  2. Claude Code:"
echo "     Run:  claude"
echo "     Authenticate with your Anthropic API key or login."
echo ""
echo "  3. Avante AI (optional — existing config):"
echo "     Export API keys for the providers you want to use:"
echo "       export OPENROUTER_API_KEY='your-key'"
echo "       export GEMINI_API_KEY='your-key'"
echo "       export DEEPSEEK_API_KEY='your-key'"
echo ""
echo "  4. Launch Neovim:"
echo "     nvim              # regular start"
echo "     v                 # alias (after shell restart)"
echo ""
echo "  5. Font setup:"
echo "     Set your terminal emulator font to 'JetBrainsMono Nerd Font'"
echo "     or 'FiraCode Nerd Font' for icon support."
echo ""
