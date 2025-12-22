-- Pull in the wezterm API
local wezterm = require 'wezterm'
local dimmer = { brightness = 0.05 }

-- This will hold the configuration.
local config = wezterm.config_builder()
local act = wezterm.action

-- src: https://www.florianbellmann.com/blog/switch-from-tmux-to-wezterm#keybindings-for-multiplexing
-- Leader is the same as tmux prefix
config.leader = { key = 'b', mods = 'CTRL', timeout_milliseconds = 1000 }
config.keys = {
  -- splitting
  {
      mods   = "LEADER|SHIFT",
      key    = '"',
      action = act.SplitVertical { domain = 'CurrentPaneDomain' }
  },
  {
      mods   = "LEADER|SHIFT",
      key    = "%",
      action = act.SplitHorizontal { domain = 'CurrentPaneDomain' }
  },
  {
      mods   = "LEADER",
      key    = "c",
      action = act.SpawnTab "CurrentPaneDomain"
  },
  { 
      mods   = 'LEADER', 
      key    = 'n', 
      action = act.ActivateTabRelative(1)
  },
  { 
      mods   = 'LEADER', 
      key    = 'p', 
      action = act.ActivateTabRelative(-1) 
  }
}

config.window_background_opacity = 0.88
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
-- config.background = {
--     {
--         source = {
--             File = '/home/ionize13/wal/hina-snow-white.jpg',
--         },
--         hsb = dimmer,
--     }
-- }
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

config.freetype_load_target = 'Light'

config.font = wezterm.font_with_fallback {
    'JetBrains Mono',
    { family = 'SOV_monospace', weight = 600, scale = 1.2}
    -- สวัสดั
}

-- config.unix_domains = {
--   {
--     name = 'unix',
--   },
-- }
--
-- -- This causes `wezterm` to act as though it was started as
-- -- `wezterm connect unix` by default, connecting to the unix
-- -- domain on startup.
-- -- If you prefer to connect manually, leave out this line.
-- config.default_gui_startup_args = { 'connect', 'unix' }
--
-- The filled in variant of the < symbol
local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider

-- The filled in variant of the > symbol
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
function tab_title(tab_info)
  local title = tab_info.tab_title
  -- if the tab title is explicitly set, take that
  if title and #title > 0 then
    return title
  end
  -- Otherwise, use the title from the active pane
  -- in that tab
  return tab_info.active_pane.title
end

wezterm.on(
  'format-tab-title',
  function(tab, tabs, panes, config, hover, max_width)
    local edge_background = '#0b0022'
    local background = '#1b1032'
    local foreground = '#808080'

    if tab.is_active then
      background = '#2b2042'
      foreground = '#c0c0c0'
    elseif hover then
      background = '#3b3052'
      foreground = '#909090'
    end

    local edge_foreground = background

    local title = tab_title(tab)

    -- ensure that the titles fit in the available space,
    -- and that we have room for the edges.
    title = wezterm.truncate_right(title, max_width - 2)

    return {
      { Background = { Color = edge_background } },
      { Foreground = { Color = edge_foreground } },
      { Text = SOLID_LEFT_ARROW },
      { Background = { Color = background } },
      { Foreground = { Color = foreground } },
      { Text = title },
      { Background = { Color = edge_background } },
      { Foreground = { Color = edge_foreground } },
      { Text = SOLID_RIGHT_ARROW },
    }
  end
)

-- Finally, return the configuration to wezterm:
return config
