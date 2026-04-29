-- Main Monitor
hl.monitor {
    output = "DP-2",
    mode = "2560x1440@165",
    position = "0x0",
    scale = 1,
    bitdepth = 10,
    cm = "srgb", -- hdredid
    sdrbrightness = 1.11,
    sdrsaturation = 1,
}

-- Second Monitor
hl.monitor {
    output = "HDMI-A-1", -- DP-3
    mode = "1920x1080",
    position = "2560x300",
    scale = 1,
    bitdepth = 8,
    cm = "auto",
}
