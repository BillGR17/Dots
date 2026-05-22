-- Tokyo Night Storm Theme Colors
local bg         = "rgb(24283b)"
local bg_dark    = "rgb(1f2335)"
local comment    = "rgb(5c637c)"
local fg         = "rgb(c0caf5)"
local fg_dark    = "rgb(a9b1d6)"
local red        = "rgb(f7768e)"
local blue       = "rgb(7aa2f7)"
local magenta    = "rgb(bb9af7)"

hl.config({
  general = {
    gaps_in           = 0,
    gaps_out          = 0,
    border_size       = 0,
    col = {
      active_border   = blue,
      inactive_border = comment,
    },
    resize_on_border  = false,
    allow_tearing     = false,
    layout            = "dwindle",
  },

  decoration = {
    rounding         = 0,
    rounding_power   = 0,
    active_opacity   = 1.0,
    inactive_opacity = 1.0,
    shadow = {
      enabled      = false,
    },
    blur = {
      enabled   = false,
    },
  },

  group = {
    col = {
      border_active   = blue,
      border_inactive = comment,
    },
  },

  animations = {
    enabled = false,
  },

  dwindle = {
    preserve_split = true,
    permanent_direction_override = false,
    force_split = 2,
  },

  render = {
    direct_scanout = false,
  },

  misc = {
    background_color = "rgb(3b4252)",
    disable_hyprland_logo = true,
    force_default_wallpaper = 0,
  },
})
