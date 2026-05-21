hl.monitor({
  output   = "DP-1",
  mode     = "2560x1440@165",
  position = "0x0",
  scale    = 1,
  bitdepth = 24,
  vrr      = 1,
})

-- Wildcard monitor fallback for other displays
hl.monitor({
  output   = "",
  mode     = "preferred",
  position = "auto",
})

local primary = "DP-1"
local secondary = "DP-1" -- Map to same monitor or secondary display as needed

local primary_workspaces = { 0, 1, 3, 5, 7, 9 }
local secondary_workspaces = { 2, 4, 6, 8 }

for _, ws in ipairs(primary_workspaces) do
  hl.workspace_rule({
    workspace = tostring(ws),
    monitor = primary,
  })
end

for _, ws in ipairs(secondary_workspaces) do
  hl.workspace_rule({
    workspace = tostring(ws),
    monitor = secondary,
  })
end
