-- Sticky Picture-in-Picture
hl.window_rule({
  name = "picture-in-picture",
  match = { title = "^(Picture-in-Picture)$" },
  float = true,
  pin = true,
  size = "monitor_w*0.15 monitor_h*0.15",
  move = "monitor_w*0.85 0",
})

-- Assign Steam & Wine to workspace 0
hl.window_rule({
  name = "steam",
  match = { class = "steam.*" },
  workspace = "10 silent",
})
hl.window_rule({
  name = "wine",
  match = { class = "wine.*" },
  workspace = "10 silent",
})
hl.window_rule({
  name = "wine-exe",
  match = { class = ".*%.exe" },
  workspace = "10 silent",
})

-- imv image viewer fullscreen
hl.window_rule({
  name = "imv",
  match = { class = "imv" },
  float = true,
  fullscreen = true,
})

-- General floating windows matching your i3wm config
local floating_classes = {
  "[Tt]ransmission.*",
  "mpv",
  "[Bb]lueman-manager",
  "vrmonitor",
  "SteamVR",
  ".*%.exe",
}

for _, cls in ipairs(floating_classes) do
  hl.window_rule({
    name = "float-" .. cls:gsub("[%[%]%*%.]", ""),
    match = { class = cls },
    float = true,
  })
end

local floating_titles = {
  "pop%-up",
  "bubble",
  "task_dialog",
  "Preferences",
}

for _, t in ipairs(floating_titles) do
  hl.window_rule({
    name = "float-title-" .. t:gsub("[%[%]%*%.%-]", ""),
    match = { title = t },
    float = true,
  })
end

hl.window_rule({
  name = "float-shutdown",
  match = { class = "org.gtk.shutitdown", title = "Shutdown PC" },
  float = true,
  center = true,
})

-- Standard drag/maximize fixes
hl.window_rule({
  name = "suppress-maximize",
  match = { class = ".*" },
  suppress_event = "maximize",
})
hl.window_rule({
  name = "focus-drag-fix",
  match = {
    class      = "^$",
    title      = "^$",
    xwayland   = true,
    float      = true,
    fullscreen = false,
    pin        = false,
  },
  no_focus = true,
})

-- Center all floating windows except ueberzug
hl.window_rule({
  name = "center-all-floating",
  match = { float = true, class = "negative:ueberzugpp.*$" },
  center = true,
})

-- Fix Yazi image preview (ueberzugpp) flashing/tiling
hl.window_rule({
  name = "ueberzugpp",
  match = { class = "^ueberzug.*" },
  float = true,
  no_focus = true,
})

