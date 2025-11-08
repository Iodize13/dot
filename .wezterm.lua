-- Pull in the wezterm API
local wezterm = require 'wezterm'
local dimmer = { brightness = 0.05 }

-- This will hold the configuration.
local config = wezterm.config_builder()

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
-- Finally, return the configuration to wezterm:
return config
