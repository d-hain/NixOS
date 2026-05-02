hl.device {
  name = "hid-256c:006e",
  output = "DP-2",
  active_area_size = "221, 138",
}

-------------------
--- ENVIRONMENT ---
-------------------

-- Cursor
hl.env("XCURSOR_THEME", "Banana")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "Banana")
hl.env("HYPRCURSOR_SIZE", "24")

-- Japanese Input
-- hl.env("GTK_IM_MODULE", "uim")
-- hl.env("QT_IM_MODULE",  "uim")
-- hl.env("XMODIFIERS",    "@im=uim")

-- GTK Apps use Portal File Picker (pls use KDE, I beg)
hl.env("GTK_USE_PORTAL", "1")

-- Electron Apps should use Wayland
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-- Flatpak apps (aka Hytale)
hl.env("XDG_DATA_DIRS", "$XDG_DATA_DIRS:/home/dhain/.local/share/flatpak/exports/share")

---------------
--- STARTUP ---
---------------

hl.on("hyprland.start", function()
  -- Default Browser for opening links
  hl.exec_cmd("xdg-mime default brave.desktop x-scheme-handler/http")
  hl.exec_cmd("xdg-mime default brave.desktop x-scheme-handler/https")

  -- Clipboard Manager
  hl.exec_cmd("wl-paste --type text --watch cliphist store")
  hl.exec_cmd("wl-paste --type image --watch cliphist store")

  -- Top Bar
  hl.exec_cmd("waybar")

  -- Banana Cursor
  hl.exec_cmd("hyprctl setcursor 'Banana' 24")
  -- GTK Cursor Theme
  hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-theme 'Banana'")
  hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-size 24")

  -- Japanese input
  -- hl.exec_cmd("uim-xim")

  -- Synology Drive Client
  hl.exec_cmd("synology-drive")
end)

--------------
--- CONFIG ---
--------------

hl.config {
  cursor = {
    no_warps = true,
  },

  input = {
    kb_layout = "de",
    kb_variant = "nodeadkeys",
    kb_model = "",
    kb_options = "",
    kb_rules = "",
    numlock_by_default = true,

    follow_mouse = 2,
    sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

    touchpad = {
      natural_scroll = true,
    },
  },

  binds = {
    window_direction_monitor_fallback = false,
  },
}

require("bindings")

---------------------
--- LOOK AND FEEL ---
---------------------

local col_text = "rgb(abb2bf)"
local col_bg = "rgb(21252b)"
local col_bg_highlight = "rgb(323844)"
local col_purple = "rgb(c678dd)"
local col_green = "rgb(98c379)"

hl.config {
  render = {
    cm_auto_hdr = 2,
  },

  general = {
    gaps_in = 3,
    gaps_out = 3,
    border_size = 2,
    col = {
      active_border = { colors = { col_purple, col_green }, angle = 90 },
    },

    -- Please see https://wiki.hyprland.org/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
    allow_tearing = true,
    no_focus_fallback = true,

    layout = "dwindle",
  },

  decoration = {
    shadow = {
      enabled = false,
    },
  },

  animations = {
    enabled = false, -- fast as fuck boiiii
  },

  dwindle = {
    preserve_split = true, -- you probably want this
    force_split = 2,
  },

  misc = {
    force_default_wallpaper = 2,
    disable_hyprland_logo = false, -- If true disables the random hyprland logo / anime girl background. :(

    vrr = 3,
    mouse_move_enables_dpms = true,
    key_press_enables_dpms = true,
    focus_on_activate = true,
    allow_session_lock_restore = true,
  },

  debug = {
      disable_logs = false,
  },
}

--------------------
--- WINDOW RULES ---
--------------------

hl.window_rule {
  name = "Floating imv",
  match = {
    title = "^(imv)$",
  },
  float = true,
}
hl.window_rule {
  name = "Floating Debug Windows",
  match = {
    title = "^(DEBUG)$",
  },
  float = true,
}
hl.window_rule {
  name = "Floating Dolphin",
  match = {
    class = "^(org.kde.dolphin)$",
  },
  float = true,
}
hl.window_rule {
  name = "Floating KDE File Selector",
  match = {
    class = "^(org.freedesktop.impl.portal.desktop.kde)$",
  },
  float = true,
}
hl.window_rule {
  name = "Floating pavucontrol",
  match = {
    class = "^(org.pulseaudio.pavucontrol)$",
  },
  float = true,
}
hl.window_rule {
  name = "Floating Steam",
  match = {
    class = "^(steam)$",
  },
  float = true,
}
hl.window_rule {
  name = "Floating Anki",
  match = {
    class = "^(anki)$",
  },
  float = true,
}
hl.window_rule {
  name = "Anki startup size",
  match = {
    initial_title = "^(User 1 - Anki)$",
  },
  size = "900, 700",
}
hl.window_rule {
  name = "Floating GTK File Selector",
  match = {
    class = "^(xdg-desktop-portal-gtk)$",
  },
  float = true,
}
