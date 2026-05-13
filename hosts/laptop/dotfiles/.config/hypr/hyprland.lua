local home_monitor = {
  output = "HDMI-A-1",
  mode = "1920x1080@75",
  position = "0x0",
  scale = 1,
  bitdepth = 8,
  cm = "srgb",
}
-- local fh_beamer = {
--   output = "HDMI-A-1",
--   mode = "1920x1080@60",
--   position = "0x0",
--   scale = 1,
--   mirror = "eDP-1",
--   bitdepth = 8,
--   cm = "srgb",
-- }

-- local set = false
-- hl.bind(mod .. "+ M", function()
--   set = not set
--   if set then
    hl.monitor(home_monitor)
--   else
--     hl.monitor(fh_beamer)
--   end
-- end)

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

----------------------------
--- BATTERY NOTIFICATION ---
----------------------------

local battery_notification = hl.timer(function ()
  local battery_capacity = hl.exec_cmd("cat /sys/class/power_supply/BAT1/capacity")

  -- NOTE: Test
  -- hl.notification.create { text = "Battery <= " .. tostring(battery_capacity), duration = 1000 * 10, color = col_purple }

  -- if battery_capacity <= 10 then
  --   hl.notification.create { text = "Battery <= 10%", duration = 1000 * 10, color = col_purple }
  -- elseif battery_capacity <= 20 then
  --   hl.notification.create { text = "Battery <= 20%", duration = 1000 * 10,  color = col_purple }
  -- end
end, { timeout = 1000, type = "repeat" })
battery_notification:set_enabled(true)
