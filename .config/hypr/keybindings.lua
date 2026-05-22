local mainMod = "SUPER"

-- Basic utility binds
hl.bind(mainMod .. " + Return",    hl.dsp.exec_cmd("alacritty"))
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.window.close())
hl.bind("ALT + F4",                hl.dsp.window.close())
hl.bind(mainMod .. " + X",         hl.dsp.exec_cmd("xkill"))
hl.bind(mainMod .. " + SHIFT + SPACE", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + F",         hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + D",         hl.dsp.exec_cmd("rofi -show run"))

hl.bind(mainMod .. " + H",         hl.dsp.layout("preselect r"))
hl.bind(mainMod .. " + V",         hl.dsp.layout("preselect d"))
hl.bind(mainMod .. " + E",         hl.dsp.layout("togglesplit"))

hl.bind(mainMod .. " + S",         hl.dsp.exec_cmd("hyprctl dispatch togglegroup"))
hl.bind(mainMod .. " + W",         hl.dsp.exec_cmd("hyprctl dispatch togglegroup"))
hl.bind(mainMod .. " + A",         hl.dsp.exec_cmd("hyprctl dispatch focuscurrentorlast"))
hl.bind(mainMod .. " + SPACE",     hl.dsp.exec_cmd("hyprctl dispatch cyclenext"))

hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("hyprctl dispatch pin"))


-- System control
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"))

-- Easy Cursor, Dunst pop, Greenclip clipboard
hl.bind(mainMod .. " + SHIFT + Escape", hl.dsp.exec_cmd("dunstctl history-pop"))
hl.bind("CTRL + ALT + H",              hl.dsp.exec_cmd("rofi -modi \"clipboard:greenclip print\" -show clipboard -run-command '{cmd}'"))

-- Focus navigation (SUPER + Arrow keys)
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Window movement (SUPER + SHIFT + Arrow keys)
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.move({ direction = "d" }))

-- Workspace focus bindings (0-9 + grave)
for i = 1, 10 do
  local key = i % 10
  hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
  hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i, follow = false }))
end
hl.bind(mainMod .. " + grave",         hl.dsp.focus({ workspace = 0 }))
hl.bind(mainMod .. " + SHIFT + grave", hl.dsp.window.move({ workspace = 0, follow = false }))

-- Mouse dragging/resizing
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Resize submap (SUPER + r)
hl.bind(mainMod .. " + r", hl.dsp.submap("resize"))
hl.define_submap("resize", function()
  hl.bind("left",   hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
  hl.bind("right",  hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })
  hl.bind("up",     hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })
  hl.bind("down",   hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })

  hl.bind("escape", hl.dsp.submap("reset"))
  hl.bind("return", hl.dsp.submap("reset"))
end)

-- Laptop multimedia volume & brightness control (using pactl to match your i3 config)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ +1%"),   { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ -1%"),   { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("pactl set-source-mute @DEFAULT_SOURCE@ toggle"), { locked = true, repeating = true })
hl.bind(mainMod .. " + C",      hl.dsp.exec_cmd("pactl set-source-mute @DEFAULT_SOURCE@ toggle"))
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),              { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),              { locked = true, repeating = true })

-- Audio playerctl keys
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl pause"),      { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

-- Screenshots & Screen Recording
hl.bind("Print",                hl.dsp.exec_cmd("screenshot current"))
hl.bind("CTRL + SHIFT + Print", hl.dsp.exec_cmd("screenshot root"))
hl.bind("SHIFT + Print",        hl.dsp.exec_cmd("screenshot"))
hl.bind(mainMod .. " + F12",         hl.dsp.exec_cmd("record /mnt/Storage"))
hl.bind(mainMod .. " + SHIFT + F12", hl.dsp.exec_cmd("killall ffmpeg"))
