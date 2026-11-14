# Omarchy dotfiles

My configs for [Omarchy](https://omarchy.org/) (Arch Linux + Hyprland), on an ASUS Zenbook S14.
The older Hyprland/Waybar/Rofi setup lives on the `master` branch.

Each folder maps to `~/.config/<folder>`; the loose files go straight into `~/.config/`.

## What's here

| Path | What |
|---|---|
| `hypr/` | Hyprland (Lua) overrides on top of Omarchy: keybindings, input (natural scroll, 3-finger workspace swipe), autostart |
| `fish/` | fish shell: vi mode, aliases, functions, mise/zoxide/fzf, Starship, auto-starts tmux |
| `starship.toml` | Starship prompt (teal theme) |
| `tmux/` | tmux: `C-Space` prefix, Nova theme, vim-tmux-navigator, resurrect/continuum, image passthrough |
| `nvim/` | LazyVim + Omarchy theme sync, my old shortcuts, Claude Code, DAP, Rust, Markdown, Diffview, images |
| `ghostty/` | Ghostty terminal (default): 3px padding, launches fish → tmux |
| `omarchy/` | Omarchy shell/bar, menu extensions, hooks |
| `pacman/makepkg.conf` | Faster AUR builds: all cores, no tests/debug/LTO |
| `foot/`, `alacritty/`, `kitty/` | Other terminals |
| `btop/`, `zed/`, `herdr/`, `imv/`, `fcitx5/`, `wireplumber/`, `xdg-desktop-portal/`, `environment.d/`, `autostart/` | App configs |
| `xdg-terminals.list`, `mimeapps.list`, `chromium-flags.conf` | Default terminal, default apps, Chromium flags |

## Key shortcuts (Hyprland)

| Keys | Action |
|---|---|
| `SUPER + SPACE` | Omarchy menu |
| `SUPER + D` | App list |
| `SUPER + V` / `SUPER + SHIFT + V` | Clipboard history / universal paste |
| `SUPER + SHIFT + T` | Microsoft Teams |
| `SUPER + SHIFT + W` | WhatsApp |
| `CTRL + SHIFT + ESC` | btop (task manager) |
| `SUPER + SHIFT + scroll` | Cycle and raise windows on the workspace |
| `SUPER + W` | Disabled (`SUPER + Q` closes windows) |

## Restore

```bash
git clone -b omarchy https://github.com/thearpankumar/dotfiles.git ~/dotfiles-omarchy
cd ~/dotfiles-omarchy
for d in */; do cp -r "$d" ~/.config/; done
cp starship.toml xdg-terminals.list mimeapps.list chromium-flags.conf ~/.config/
chsh -s /usr/bin/fish
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm   # then prefix + I in tmux
hyprctl reload
```

Symlinks such as `nvim/lua/plugins/theme.lua` and `btop/themes/current.theme` point into
`~/.local/state/omarchy/current/theme/`, so apps follow whatever Omarchy theme is active.

Not included on purpose: browser profiles, `gh` credentials, git identity, and app data.
