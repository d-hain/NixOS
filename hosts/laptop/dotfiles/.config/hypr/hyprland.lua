-- Main Monitor
-- hl.monitor {
--   output = "HDMI-A-1",
--   mode = "1920x1080@75",
--   position = "0x0",
--   scale = 1,
--   bitdepth = 8,
--   cm = "srgb",
-- }

-- TODO: Make toggle-able with HyprLua
-- FH Beamer
hl.monitor {
  output = "HDMI-A-1",
  mode = "1920x1080@60",
  position = "0x0",
  scale = 1,
  mirror = "eDP-1",
  bitdepth = 8,
  cm = "srgb",
}

-- Second Monitor
hl.monitor {
  output = "eDP-1", -- Laptop inbuilt
  mode = "1920x1080@60",
  position = "1920x500",
  scale = 1.2,
  bitdepth = 8,
  cm = "srgb",
}

-- Other monitors
hl.monitor {
  output = "",
  mode = "preferred",
  position = "auto",
  scale = "auto",
}

hl.workspace_rule { workspace = "1", monitor = "HDMI-A-1" }
hl.workspace_rule { workspace = "2", monitor = "eDP-1" }
