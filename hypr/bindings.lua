-- Keep only your personal keybinding overrides here. Add new bindings with
-- o.bind or replace defaults with o.rebind.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding. o.rebind takes the same arguments as o.bind.
-- This example replaces the default file manager with Flea.
-- o.rebind("SUPER + SHIFT + F", "File manager", { launch = "flea" })

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, { panel = "omarchy.emojis" })

-- Mouse wheel window cycling (SUPER + scroll already switches workspaces).
-- SUPER + SHIFT + scroll cycles the windows stacked on the current workspace
-- and raises the focused one to the top. Mirrors the default ALT + TAB pair.
o.bind("SUPER + SHIFT + mouse_down", "Focus next window", hl.dsp.window.cycle_next())
o.bind("SUPER + SHIFT + mouse_down", "Raise window to top", hl.dsp.window.bring_to_top())
o.bind("SUPER + SHIFT + mouse_up", "Lower window", hl.dsp.window.alter_zorder({ mode = "bottom" }))
o.bind("SUPER + SHIFT + mouse_up", "Focus previous window", hl.dsp.window.cycle_next({ next = false }))

-- Disable SUPER + W (was: close window). SUPER + Q still closes windows.
hl.unbind("SUPER + W")

-- Remove Google web app shortcuts (web apps were uninstalled).
hl.unbind("SUPER + SHIFT + CTRL + G") -- was: Google Messages
hl.unbind("SUPER + SHIFT + P")        -- was: Google Photos
hl.unbind("SUPER + SHIFT + S")        -- was: Google Maps

-- Remove HEY, X and YouTube web app shortcuts.
hl.unbind("SUPER + SHIFT + C")        -- was: HEY Calendar
hl.unbind("SUPER + SHIFT + E")        -- was: HEY Email
hl.unbind("SUPER + SHIFT + ALT + E")  -- was: HEY New email
hl.unbind("SUPER + SHIFT + X")        -- was: X
hl.unbind("SUPER + SHIFT + ALT + X")  -- was: X Post
hl.unbind("SUPER + SHIFT + Y")        -- was: YouTube

-- Teams on SUPER + SHIFT + T (was: Activity / btop).
o.rebind("SUPER + SHIFT + T", "Microsoft Teams", { webapp = "https://teams.cloud.microsoft/", focus = true })

-- Task manager (btop) on CTRL + SHIFT + ESC, like Windows.
o.bind("CTRL + SHIFT + ESCAPE", "Task manager", { tui = "btop" })

-- SUPER + D opens the app list directly (same as SUPER + ALT + SPACE).
o.bind("SUPER + D", "Apps", "omarchy-shell omarchy.dock apps")

-- Clipboard history on SUPER + V; universal paste moved to SUPER + SHIFT + V.
hl.unbind("SUPER + V")
hl.unbind("SUPER + CTRL + V")
o.bind("SUPER + V", "Clipboard manager", { panel = "omarchy.clipboard" })
-- Same logic as Omarchy's default universal paste (CTRL+SHIFT+V in terminals,
-- CTRL+V elsewhere); the helpers there are local, so they're copied here.
local function universal_paste()
  local mods = "CTRL"
  local window = hl.get_active_window()
  for _, tag in ipairs((window and window.tags) or {}) do
    if tag:gsub("%*$", "") == "terminal" then mods = "CTRL SHIFT" end
  end
  hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = "V", state = "down" }))
  hl.timer(function()
    hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = "V", state = "up" }))
  end, { timeout = 50, type = "oneshot" })
end
o.bind("SUPER + SHIFT + V", "Universal paste", universal_paste)

-- WhatsApp on SUPER + SHIFT + W (was: Omawrite); old SUPER + SHIFT + ALT + G freed.
hl.unbind("SUPER + SHIFT + ALT + G")
o.rebind("SUPER + SHIFT + W", "WhatsApp", { webapp = "https://web.whatsapp.com/", focus = true })

-- Lock on SUPER + ALT + L (was: cycle workspace layout back; SUPER + L still cycles forward).
o.rebind("SUPER + ALT + L", "Lock system", "omarchy-system-lock")
hl.unbind("SUPER + CTRL + L")  -- was: Lock system (lock is on SUPER + ALT + L)
