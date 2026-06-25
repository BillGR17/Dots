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
    layout            = "master",
  },

  master = {
    allow_small_split = true
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
    enabled = true,
  },

  render = {
    direct_scanout = false,
  },

  misc = {
    background_color = "rgb(3b4252)",
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
    force_default_wallpaper = 0,
  },

  ecosystem = {
    no_update_news = true,
    no_donation_nag = true
  },

  quirks = {
    prefer_hdr = 1
  }
})
hl.curve( "anim_main", { type = "bezier", points = { {0.5, 0.9}, {0.1, 1.1} } })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1, bezier = "anim_main" })
hl.animation({ leaf = "windows", enabled = true, speed = 1, bezier = "anim_main", style = "slide"})
