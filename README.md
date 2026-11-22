# Omarchy dotfiles

My configs for [Omarchy](https://omarchy.org/) (Arch Linux + Hyprland), on an ASUS Zenbook S14.
The older Hyprland/Waybar/Rofi setup lives on the `master` branch.

Each config folder maps to `~/.config/<folder>`; the loose files go straight into `~/.config/`.
Exceptions: `local/bin/` → `~/.local/bin/`, `systemd/user/` → `~/.config/systemd/user/`,
`etc/` → `/etc/`, `usr/` → `/usr/`.

## What's here

| Path | What |
|---|---|
| `hypr/` | Hyprland (Lua) overrides on top of Omarchy: keybindings, input (natural scroll, 3-finger workspace swipe), autostart |
| `fish/` | fish shell: vi mode, aliases, functions, mise/zoxide/fzf, Starship, auto-starts tmux; `CTRL+V` pastes (fzf variable search moved to `CTRL+ALT+V`) |
| `starship.toml` | Starship prompt (teal theme) |
| `tmux/` | tmux: `C-Space` prefix, Nova theme, vim-tmux-navigator, resurrect/continuum, fish panes, image passthrough |
| `nvim/` | LazyVim + Omarchy theme sync, my old shortcuts, Claude Code, DAP, Rust, Markdown, Diffview, images |
| `ghostty/` | Ghostty terminal (default): 3px padding, launches fish → tmux |
| `omarchy/` | Omarchy shell/bar (screensaver off, lock after 5 min), menu extensions, hooks |
| `omarchy/plugins/ultron.lock/` | Custom lock screen: current wallpaper (sharp, dark tint), big clock + date, Omarchy password box |
| `omarchy/plugins/custom.monitor/` | Display panel (bar, right): adds a Mode row — Extend / Mirror / External only — when an external display is connected |
| `local/bin/omarchy-gamemode` | Game mode (`SUPER+F1`): no animations/blur/shadows, opaque windows, VRR, performance power, notifications paused; wallpaper and shortcuts unchanged |
| `local/bin/omarchy-login-wallpaper-sync`, `systemd/user/omarchy-login-wallpaper.*` | Copies the current desktop wallpaper for the SDDM login screen on every wallpaper/theme change |
| `usr/share/sddm/themes/omarchy-wallpaper/` + `etc/sddm.conf.d/zz-login-wallpaper.conf` | SDDM login theme: Omarchy password box on the desktop wallpaper, no logo |
| `usr/share/plymouth/themes/omarchy-black/` | Boot / disk-unlock screen: pure black, no logo, centred password box |
| `local/bin/omarchy-logind-lock-listener`, `systemd/user/omarchy-logind-lock.service` | Locks Omarchy on logind lock requests (lid closed on AC) |
| `etc/systemd/logind.conf.d/` | Lid closed on charger = lock only (agents keep running); on battery = suspend |
| `pacman/makepkg.conf` | Faster AUR builds: all cores, no tests/debug/LTO |
| `foot/`, `alacritty/`, `kitty/` | Other terminals |
| `btop/`, `zed/`, `herdr/`, `imv/`, `fcitx5/`, `wireplumber/`, `xdg-desktop-portal/`, `environment.d/`, `autostart/` | App configs |
| `xdg-terminals.list`, `mimeapps.list`, `chromium-flags.conf` | Default terminal, default apps, Chromium flags |

## Key shortcuts (Hyprland)

| Keys | Action |
|---|---|
| `SUPER + SPACE` | Omarchy menu |
| `SUPER + D` | App list |
| `SUPER + ALT + L` | Lock screen |
| `SUPER + F1` | Game mode on/off |
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

# Configs
for d in */; do
  case "$d" in etc/|usr/|local/|systemd/) continue ;; esac
  cp -r "$d" ~/.config/
done
cp starship.toml xdg-terminals.list mimeapps.list chromium-flags.conf ~/.config/
chsh -s /usr/bin/fish
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm   # then prefix + I in tmux
hyprctl reload

# Scripts and user services (lid lock, login wallpaper sync, game mode)
mkdir -p ~/.local/bin ~/.config/systemd/user
cp local/bin/* ~/.local/bin/
cp systemd/user/* ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user enable --now omarchy-logind-lock.service omarchy-login-wallpaper.path

# Lock screen clone
omarchy plugin enable ultron.lock && omarchy restart shell

# Display panel with Extend / Mirror / External only
omarchy plugin enable custom.monitor && omarchy restart shell

# System files (login theme, boot theme, lid behaviour)
sudo cp -r usr/share/sddm/themes/omarchy-wallpaper /usr/share/sddm/themes/
sudo cp -r usr/share/plymouth/themes/omarchy-black /usr/share/plymouth/themes/
sudo cp etc/sddm.conf.d/zz-login-wallpaper.conf /etc/sddm.conf.d/
sudo cp etc/systemd/logind.conf.d/30-lid-on-ac-lock.conf /etc/systemd/logind.conf.d/
sudo install -d -o "$USER" -g "$USER" -m 755 /var/lib/omarchy-login-wallpaper
sudo systemctl kill -s HUP systemd-logind      # reload, never restart logind
sudo plymouth-set-default-theme omarchy-black && sudo limine-update
```

Symlinks such as `nvim/lua/plugins/theme.lua` and `btop/themes/current.theme` point into
`~/.local/state/omarchy/current/theme/`, so apps follow whatever Omarchy theme is active.

Not included on purpose: browser profiles, `gh` credentials, git identity, and app data.
