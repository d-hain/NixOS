local wezterm = require "wezterm"
local config = wezterm.config_builder()

------------------
--- Appearance ---
------------------

config.color_scheme = "One Dark (Gogh)"
config.use_fancy_tab_bar = false
config.window_decorations = "NONE"
config.default_cursor_style = "SteadyBlock"
config.force_reverse_video_cursor = true
config.hide_mouse_cursor_when_typing = true
config.inactive_pane_hsb = {
  saturation = 0.8,
  brightness = 0.5,
}
config.colors = {
  foreground = "#abb2bf"
}

----------------
--- Keybinds ---
----------------

config.disable_default_key_bindings = true

local act = wezterm.action

config.keys = {
  -- Copy & Paste
  { mods = "CTRL|SHIFT", key = "c", action = act.CopyTo "Clipboard" },
  { mods = "CTRL|SHIFT", key = "v", action = act.PasteFrom "Clipboard" },

  -- Font size
  { mods = "CTRL", key = "+", action = act.IncreaseFontSize },
  { mods = "CTRL", key = "-", action = act.DecreaseFontSize },

  -- Tabs
  { mods = "CTRL", key = "t", action = act.SpawnTab "CurrentPaneDomain" },
  { mods = "CTRL", key = "w", action = act.CloseCurrentPane { confirm = false } },

  { mods = "CTRL", key = "1", action = act.ActivateTab(0) },
  { mods = "CTRL", key = "2", action = act.ActivateTab(1) },
  { mods = "CTRL", key = "3", action = act.ActivateTab(2) },
  { mods = "CTRL", key = "4", action = act.ActivateTab(3) },
  { mods = "CTRL", key = "5", action = act.ActivateTab(4) },
  { mods = "CTRL", key = "6", action = act.ActivateTab(5) },
  { mods = "CTRL", key = "7", action = act.ActivateTab(6) },
  { mods = "CTRL", key = "8", action = act.ActivateTab(7) },
  { mods = "CTRL", key = "9", action = act.ActivateTab(8) },

  { mods = "CTRL",           key = "Tab", action = act.ActivateTabRelative(1) },
  { mods = "CTRL|SHIFT",     key = "Tab", action = act.ActivateTabRelative(-1) },
  { mods = "CTRL|SHIFT|ALT", key = "h",   action = act.MoveTabRelative(-1) },
  { mods = "CTRL|SHIFT|ALT", key = "l",   action = act.MoveTabRelative(1) },
}

return config
