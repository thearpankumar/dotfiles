# Claude Code plugins

Plugins installed in Claude Code (user scope).

## Marketplaces

| Marketplace | Link |
|---|---|
| claude-plugins-official | https://github.com/anthropics/claude-plugins-official |
| ponytail | https://github.com/DietrichGebert/ponytail |
| caveman | https://github.com/JuliusBrussee/caveman |

## Plugins

| Plugin | Marketplace | What it does | Link |
|---|---|---|---|
| superpowers | claude-plugins-official (synced from claude.ai) | Skill library: brainstorming, TDD, debugging, plans | https://github.com/obra/superpowers |
| ponytail | ponytail | Makes Claude reuse existing code/stdlib before writing new code | https://github.com/DietrichGebert/ponytail |
| caveman | caveman | Ultra-terse replies to cut output tokens (`/caveman`, `/caveman-stats`); local hooks only, no telemetry | https://github.com/JuliusBrussee/caveman |
| frontend-design | claude-plugins-official | Distinctive, production-grade UI design | https://github.com/anthropics/claude-plugins-official/tree/main/plugins/frontend-design |
| feature-dev | claude-plugins-official | Guided feature workflow with explore/architect/review agents | https://github.com/anthropics/claude-plugins-official/tree/main/plugins/feature-dev |
| code-review | claude-plugins-official | Multi-agent PR review | https://github.com/anthropics/claude-plugins-official/tree/main/plugins/code-review |
| security-guidance | claude-plugins-official | Warns about insecure code as it's written | https://github.com/anthropics/claude-plugins-official/tree/main/plugins/security-guidance |
| skill-creator | claude-plugins-official | Create and evaluate custom skills | https://github.com/anthropics/claude-plugins-official/tree/main/plugins/skill-creator |
| playwright | claude-plugins-official | Browser automation via Playwright MCP | https://github.com/microsoft/playwright-mcp |
| chrome-devtools-mcp | claude-plugins-official | Control/inspect live Chrome | https://github.com/ChromeDevTools/chrome-devtools-mcp |
| github | claude-plugins-official | GitHub MCP server (needs `GITHUB_PERSONAL_ACCESS_TOKEN`) | https://github.com/github/github-mcp-server |

## Reinstall

```sh
claude plugin marketplace add anthropics/claude-plugins-official
claude plugin marketplace add DietrichGebert/ponytail
claude plugin marketplace add JuliusBrussee/caveman

claude plugin install ponytail@ponytail
claude plugin install caveman@caveman   # update: claude plugin update caveman@caveman
for p in superpowers frontend-design feature-dev code-review security-guidance skill-creator playwright chrome-devtools-mcp github; do
  claude plugin install "$p@claude-plugins-official"
done
```

GitHub plugin token (fish, `~/.config/fish/config.fish`):

```fish
set -gx GITHUB_PERSONAL_ACCESS_TOKEN (gh auth token)
```

## Headroom (context compression proxy)

[Headroom](https://github.com/chopratejas/headroom) sits between Claude Code and the API and compresses context.
Only the `proxy` extra is needed for Claude Code (`[all]` pulls OCR/embeddings/etc.).

```sh
uv tool install --python 3.13 "headroom-ai[proxy]"
headroom doctor          # health check
headroom wrap claude     # launch Claude Code through the proxy (127.0.0.1:8787)
```

Telemetry beacon is on by default; disabled in `~/.config/fish/config.fish`:

```fish
set -gx HEADROOM_TELEMETRY off
```

On Omarchy, `uv` is also a lazy mise tool; `disable_tools = ["uv"]` in `~/.config/mise/config.toml`
keeps the standalone `~/.local/bin/uv` (see the `omarchy` branch).

## Shift+Enter inside tmux

Terminals (alacritty/ghostty/foot) send Shift+Enter as CSI-u; tmux must pass it through.
Add to `~/.config/tmux/tmux.conf`:

```tmux
set -s extended-keys on
set -s extended-keys-format csi-u
set -as terminal-features ',*:extkeys'
```

## Status line

Shows `model │ ctx % │  branch`. Script: [`statusline.sh`](statusline.sh)

```sh
cp claude/statusline.sh ~/.claude/statusline.sh && chmod +x ~/.claude/statusline.sh
```

Add to `~/.claude/settings.json`:

```json
"statusLine": {
  "type": "command",
  "command": "bash ~/.claude/statusline.sh"
}
```
