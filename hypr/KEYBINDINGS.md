# Hyprland Keybindings

Config source: [`hyprland.lua`](.config/hypr/hyprland.lua). Main modifier (`mainMod`) is `SUPER` (the Windows key).

## Apps & Windows
- `SUPER + Enter` - Open terminal
- `SUPER + Q` - Close window (graceful)
- `SUPER + Shift + Q` - Kill window (force)
- `SUPER + E` - Open file manager
- `SUPER + B` - Open browser (Google Chrome)
- `SUPER + F` - Toggle floating
- `SUPER + P` - Pseudotile
- `SUPER + J` - Toggle split (dwindle layout only)
- `SUPER + C` - Copy (sends Ctrl+C)
- `SUPER + V` - Paste (sends Ctrl+V)
- `SUPER + L` - Lock session
- `SUPER + M` - Shutdown/exit
- `SUPER + Tab` / `Alt + Tab` - Open window switcher (noctalia)
- `SUPER + Space` - Toggle launcher (noctalia)

## Focus & Movement
- `SUPER + ←/→/↑/↓` - Move focus
- `SUPER + Shift + ←/→/↑/↓` - Resize window
- `SUPER + drag (LMB)` - Move window
- `SUPER + drag (RMB)` - Resize window

## Fullscreen
- `SUPER + Ctrl + F` - Toggle maximize
- `SUPER + Shift + F` - Toggle fullscreen

## Workspaces
- `SUPER + [0-9]` - Switch to workspace
- `SUPER + Shift + [0-9]` - Move window to workspace and follow
- `SUPER + Ctrl + [0-9]` - Move window to workspace, stay on current
- `SUPER + scroll` - Cycle through existing workspaces
- `Ctrl + Alt + ←/→` - Cycle through existing workspaces (keyboard equivalent of `SUPER + scroll`)
- `Ctrl + Alt + N` - Jump to an empty workspace, creating one if none exist
- `SUPER + S` - Toggle special/scratchpad workspace
- `SUPER + Shift + S` - Move window to special/scratchpad workspace

## Screenshots
- `Print` - Screenshot (fullscreen, with picker)
- `SUPER + Print` - Screenshot region
- `Alt + Shift + S` - Screenshot a selected area with flameshot

## Media & Brightness
- `XF86AudioRaiseVolume` / `XF86AudioLowerVolume` - Volume up/down
- `XF86AudioMute` - Toggle mute
- `XF86AudioMicMute` - Toggle mic mute
- `XF86MonBrightnessUp` / `XF86MonBrightnessDown` - Brightness up/down
- `XF86AudioNext` / `XF86AudioPrev` - Next/previous track (requires `playerctl`)
- `XF86AudioPlay` / `XF86AudioPause` - Play/pause (requires `playerctl`)
