local wezterm = require 'wezterm'

local config = wezterm.config_builder()

-- Font
config.font = wezterm.font('MesloLGM Nerd Font Mono')
config.font_size = 11.0 -- default, overridden by local.lua if present

-- Load machine-specific config (font size, etc.) - not tracked in git
local local_config_path = wezterm.config_dir .. '/local.lua'
local f = io.open(local_config_path, 'r')
if f then
  f:close()
  local local_config = dofile(local_config_path)
  if local_config and local_config.font_size then
    config.font_size = local_config.font_size
  end
end

-- Theme
config.color_scheme = 'Catppuccin Mocha'

-- No tab bar (use zellij for multiplexing)
config.enable_tab_bar = false

-- No quit confirmation
config.window_close_confirmation = 'NeverPrompt'

-- Window decorations
config.window_decorations = 'TITLE | RESIZE'

-- Padding
config.window_padding = {
  left = 4,
  right = 4,
  top = 4,
  bottom = 4,
}

-- Default to WSL on Windows
if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
  config.default_prog = { 'wsl.exe', '--cd', '~' }
end

return config
