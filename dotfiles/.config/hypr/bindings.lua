-- Bindings
-- For Key Names see: https://github.com/xkbcommon/libxkbcommon/blob/master/include/xkbcommon/xkbcommon-keysyms.h
local mod = "SUPER"

-- Main Bindings
hl.bind(mod ..         "+ Q",     hl.dsp.window.close())
hl.bind(mod ..         "+ F",     hl.dsp.window.fullscreen { mode = "maximized" })
hl.bind(mod .. "+ SHIFT + F",     hl.dsp.window.fullscreen { mode = "fullscreen" })
hl.bind(mod ..         "+ SPACE", hl.dsp.window.float { action = "toggle" })
hl.bind(mod .. "+ SHIFT + E",     hl.dsp.exit())
hl.bind(mod ..         "+ TAB",   hl.dsp.window.cycle_next())
hl.bind(mod .. "+ SHIFT + TAB",   hl.dsp.window.cycle_next { next = false })

-- Desktop like things
-- Flameshot is broken on wayland
-- hl.bind(mod .. "+ SHIFT + S", hl.dsp.exec_cmd("flameshot gui"))
hl.bind(mod ..        " + D",      hl.dsp.exec_cmd("fuzzel"))
hl.bind(mod .. "+ SHIFT + S",      hl.dsp.exec_cmd("hyprshot -z -m region --clipboard-only"))
hl.bind(mod .. "+ SHIFT + R",      hl.dsp.exec_cmd("hyprctl reload"))
hl.bind(mod ..        " + V",      hl.dsp.exec_cmd("cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"))
hl.bind(mod ..        " + P",      hl.dsp.exec_cmd("fuzzel-pass --type"))
hl.bind(mod ..        " + period", hl.dsp.exec_cmd("rofimoji -a copy -s neutral -r '> ' --selector fuzzel --clipboarder wl-copy"))
hl.bind(mod .. "+ SHIFT + P",      hl.dsp.exec_cmd("hyprlock"))
hl.bind(mod .. " + SHIFT + W",     hl.dsp.exec_cmd("pkill -9 waybar || waybar"))

-- Apps
hl.bind(mod .. "+ RETURN", hl.dsp.exec_cmd("ghostty"))
hl.bind(mod .. "+ E",      hl.dsp.exec_cmd("dolphin"))
hl.bind(mod .. "+ B",      hl.dsp.exec_cmd("brave"))
hl.bind(mod .. "+ I",      hl.dsp.exec_cmd("gimp"))


-- TODO: Global Keybinds
-- bind = SUPER, code:82, sendshortcut, CTRL SHIFT, M, class:^(vesktop)$
-- bind = SUPER, code:86, sendshortcut, CTRL SHIFT, D, class:^(vesktop)$
-- bind = SUPER, N, sendshortcut, CTRL SHIFT, D, class:^(vesktop)$ # Testing

-- NOTE: The Ghostty one work but the Vesktop ones don't
-- bind = SUPER, T, sendshortcut, CTRL, T, class:^(com.mitchellh.ghostty)$
-- bind = CTRL, T, pass, class:^(com.mitchellh.ghostty)$
-- bind = SUPER SHIFT, D, sendshortcut, CTRL SHIFT, D, class:^(vesktop)$
-- bind = CTRL SHIFT, D, pass, class:^(vesktop)$

-- Hacky workaround for Vesktop global shortcuts
-- See: https://github.com/hyprwm/Hyprland/discussions/10351#discussioncomment-13181422
-- Vesktop Toggle Mute
hl.bind("Pause", hl.dsp.focus { window = "class:^(vesktop)$" })
hl.bind("Pause", hl.dsp.send_shortcut { mods = "CTRL SHIFT", key = "M", window = "class:^(vesktop)$" })
hl.bind("Pause", hl.dsp.focus { last = true })
-- Vesktop Toggle Deafen
hl.bind("Scroll_Lock", hl.dsp.focus { window = "class:^(vesktop)$" })
hl.bind("Scroll_Lock", hl.dsp.send_shortcut { mods = "CTRL SHIFT", key = "D", window = "class:^(vesktop)$" })
hl.bind("Scroll_Lock", hl.dsp.focus { last = true })

-- Media Keys
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl s +5%"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 5%-"))
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"))
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))

-- Split
hl.bind(mod .. "+ S", hl.dsp.layout("togglesplit")) -- dwindle

-- Move focus
hl.bind(mod .. "+ left",  hl.dsp.focus { direction = "l" })
hl.bind(mod .. "+ H",     hl.dsp.focus { direction = "l" })
hl.bind(mod .. "+ right", hl.dsp.focus { direction = "r" })
hl.bind(mod .. "+ L",     hl.dsp.focus { direction = "r" })
hl.bind(mod .. "+ up",    hl.dsp.focus { direction = "u" })
hl.bind(mod .. "+ K",     hl.dsp.focus { direction = "u" })
hl.bind(mod .. "+ down",  hl.dsp.focus { direction = "d" })
hl.bind(mod .. "+ J",     hl.dsp.focus { direction = "d" })

-- Switch workspaces
hl.bind(mod .. "+ 1", hl.dsp.focus { workspace = 1 })
hl.bind(mod .. "+ 2", hl.dsp.focus { workspace = 2 })
hl.bind(mod .. "+ 3", hl.dsp.focus { workspace = 3 })
hl.bind(mod .. "+ 4", hl.dsp.focus { workspace = 4 })
hl.bind(mod .. "+ 5", hl.dsp.focus { workspace = 5 })
hl.bind(mod .. "+ 6", hl.dsp.focus { workspace = 6 })
hl.bind(mod .. "+ 7", hl.dsp.focus { workspace = 7 })
hl.bind(mod .. "+ 8", hl.dsp.focus { workspace = 8 })
hl.bind(mod .. "+ 9", hl.dsp.focus { workspace = 9 })
hl.bind(mod .. "+ 0", hl.dsp.focus { workspace = 10 })

-- Move active window to a workspace
hl.bind(mod .. "+ SHIFT + 1", hl.dsp.window.move { workspace = 1 })
hl.bind(mod .. "+ SHIFT + 2", hl.dsp.window.move { workspace = 2 })
hl.bind(mod .. "+ SHIFT + 3", hl.dsp.window.move { workspace = 3 })
hl.bind(mod .. "+ SHIFT + 4", hl.dsp.window.move { workspace = 4 })
hl.bind(mod .. "+ SHIFT + 5", hl.dsp.window.move { workspace = 5 })
hl.bind(mod .. "+ SHIFT + 6", hl.dsp.window.move { workspace = 6 })
hl.bind(mod .. "+ SHIFT + 7", hl.dsp.window.move { workspace = 7 })
hl.bind(mod .. "+ SHIFT + 8", hl.dsp.window.move { workspace = 8 })
hl.bind(mod .. "+ SHIFT + 9", hl.dsp.window.move { workspace = 9 })
hl.bind(mod .. "+ SHIFT + 0", hl.dsp.window.move { workspace = 10 })

-- Move windows
hl.bind(mod .. "+ SHIFT + left",  hl.dsp.window.move { direction = "l" })
hl.bind(mod .. "+ SHIFT + H",     hl.dsp.window.move { direction = "l" })
hl.bind(mod .. "+ SHIFT + right", hl.dsp.window.move { direction = "r" })
hl.bind(mod .. "+ SHIFT + L",     hl.dsp.window.move { direction = "r" })
hl.bind(mod .. "+ SHIFT + up",    hl.dsp.window.move { direction = "u" })
hl.bind(mod .. "+ SHIFT + K",     hl.dsp.window.move { direction = "u" })
hl.bind(mod .. "+ SHIFT + down",  hl.dsp.window.move { direction = "d" })
hl.bind(mod .. "+ SHIFT + J",     hl.dsp.window.move { direction = "d" })

-- Resize windows
hl.bind(mod .. "+ ALT + left",  hl.dsp.window.resize { x = -15, y =   0, relative = true }, { repeating = true })
hl.bind(mod .. "+ ALT + H",     hl.dsp.window.resize { x = -15, y =   0, relative = true }, { repeating = true })
hl.bind(mod .. "+ ALT + right", hl.dsp.window.resize { x =  15, y =   0, relative = true }, { repeating = true })
hl.bind(mod .. "+ ALT + L",     hl.dsp.window.resize { x =  15, y =   0, relative = true }, { repeating = true })
hl.bind(mod .. "+ ALT + up",    hl.dsp.window.resize { x =   0, y = -15, relative = true }, { repeating = true })
hl.bind(mod .. "+ ALT + K",     hl.dsp.window.resize { x =   0, y = -15, relative = true }, { repeating = true })
hl.bind(mod .. "+ ALT + down",  hl.dsp.window.resize { x =   0, y =  15, relative = true }, { repeating = true })
hl.bind(mod .. "+ ALT + J",     hl.dsp.window.resize { x =   0, y =  15, relative = true }, { repeating = true })

-- Move/resize windows with LMB/RMB
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
