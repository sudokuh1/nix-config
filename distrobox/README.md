# Neovim Distrobox Development Environment

Standalone Neovim development setup for use inside a
[Distrobox](https://distrobox.it/) container — with **GitHub Copilot** and
**Claude Code** integration.

## What's Included

| Component | Details |
|-----------|---------|
| **Neovim** | Latest stable, with AstroNvim v4 framework |
| **GitHub Copilot** | `copilot.lua` plugin — inline AI suggestions |
| **Claude Code** | CLI installed globally via npm |
| **Avante.nvim** | Multi-provider AI chat (OpenRouter, Gemini, DeepSeek, …) |
| **Fonts** | JetBrains Mono NF, FiraCode NF, Symbols Only |
| **LSP Servers** | Pre-installed for Python, TypeScript, Go, Rust, Lua, Bash, … |
| **Formatters** | Prettier, Black, Stylua, shfmt, … |
| **Dev Toolchains** | Node.js, Python, Go, Rust (via rustup) |

## Quick Start

### 1. Build the Container Image

```bash
cd /path/to/nix-config
podman build -t neovim-dev -f distrobox/Containerfile .
```

### 2. Create and Enter the Distrobox

```bash
distrobox create --image neovim-dev --name nvim-dev
distrobox enter nvim-dev
```

### 3. Run Setup Inside the Distrobox

```bash
# Inside the distrobox, from the repo root:
./distrobox/setup.sh
```

This will:
- Symlink `~/.config/nvim` → the repo's neovim config
- Install Rust toolchain (if missing)
- Print instructions for API key setup

### 4. First Launch

```bash
nvim
```

Lazy.nvim will bootstrap and install all plugins on first launch.

### 5. Authenticate Services

**GitHub Copilot:**
```vim
:Copilot auth
```
Follow the browser-based authentication flow.

**Claude Code:**
```bash
claude
```
Follow the interactive authentication prompts.

## Key Bindings (AI Features)

| Key | Mode | Action |
|-----|------|--------|
| `<M-l>` (Alt+L) | Insert | Accept Copilot suggestion |
| `<M-]>` / `<M-[>` | Insert | Next / Previous Copilot suggestion |
| `<Leader>Aa` | Normal | Avante: Ask AI |
| `<Leader>Ae` | Normal | Avante: Edit with AI |
| `<Leader>Ar` | Normal | Avante: Refresh |
| `<Leader>At` | Normal | Avante: Toggle chat |

## Environment Variables (Optional)

For Avante.nvim multi-provider support, export any of:

```bash
export OPENROUTER_API_KEY='...'     # Claude via OpenRouter (default)
export GEMINI_API_KEY='...'         # Google Gemini
export DEEPSEEK_API_KEY='...'       # DeepSeek
export DASHSCOPE_API_KEY='...'      # Alibaba Qwen
export ARK_API_KEY='...'            # Volcengine
export SILICONFLOW_API_KEY='...'    # SiliconFlow
```

## Terminal Font Setup

Set your **host** terminal emulator font to one of:
- **JetBrainsMono Nerd Font** (recommended)
- **FiraCode Nerd Font**

This is required for icons and special characters in the Neovim UI.

## Updating

To pull config updates:

```bash
cd /path/to/nix-config
git pull
# Restart neovim — Lazy.nvim will sync plugins automatically
```

## Troubleshooting

**Plugins fail to install:**
```vim
:Lazy sync
```

**LSP server not found:**
Mason is set to `append` mode — it will use system packages first. Ensure
the language server is installed via the container image or install it
manually with `:MasonInstall <server>`.

**Copilot not working:**
Ensure you've authenticated with `:Copilot auth` and that your GitHub
account has Copilot access.

**Fonts look wrong:**
The Nerd Fonts are installed inside the container at
`/usr/local/share/fonts/NerdFonts`. Since Distrobox shares the host display,
you need to set the font in your **host** terminal emulator.
