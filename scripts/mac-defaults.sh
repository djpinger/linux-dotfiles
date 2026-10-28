#!/usr/bin/env bash
# macOS settings: Dock, trackpad, menu bar battery. Sourced by setup.sh for mac.
# Values captured from the reference laptop; only explicitly-set keys are written.
# Safe to re-run. Defines mac_defaults_run; setup.sh calls it.

register_section mac_dock "macOS Dock (settings + app list)"
register_section mac_trackpad "macOS trackpad"
register_section mac_battery "macOS menu bar battery percentage"

DOCK_APPS=(
  "/Applications/Safari.app"
  "/Applications/kitty.app"
  "/Applications/Ghostty.app"
  "/System/Applications/Messages.app"
  "/System/Applications/Photos.app"
  "/System/Applications/TV.app"
  "/System/Applications/Music.app"
  "/System/Applications/Games.app"
  "/System/Applications/App Store.app"
  "/System/Applications/iPhone Mirroring.app"
  "/System/Applications/System Settings.app"
  "/Applications/1Password.app"
)

mac_defaults_run() {
  if section_on mac_dock; then
    print_step "Configuring Dock"
    defaults write com.apple.dock autohide -bool false
    defaults write com.apple.dock tilesize -int 45
    defaults write com.apple.dock show-recents -bool false
    defaults write com.apple.dock mineffect -string "scale"
    defaults write com.apple.dock minimize-to-application -bool true
    defaults write com.apple.dock mru-spaces -bool false

    if cmd_exists dockutil; then
      dockutil --remove all --no-restart >/dev/null
      local app
      for app in "${DOCK_APPS[@]}"; do
        if [ -d "$app" ]; then
          dockutil --add "$app" --no-restart >/dev/null
        else
          print_warn "Skipping Dock item (not installed): $app"
        fi
      done
      dockutil --add /Applications --view list --display folder --sort name --section others --no-restart >/dev/null
      dockutil --add "$HOME/Downloads" --view list --display folder --sort dateadded --section others --no-restart >/dev/null
      print_ok "Dock items set"
    else
      print_warn "dockutil not found, leaving Dock items unchanged"
    fi
  fi

  if section_on mac_trackpad; then
    print_step "Configuring trackpad"
    local domain
    for domain in com.apple.AppleMultitouchTrackpad com.apple.driver.AppleBluetoothMultitouch.trackpad; do
      defaults write "$domain" Clicking -bool true
      defaults write "$domain" Dragging -bool false
      defaults write "$domain" TrackpadThreeFingerDrag -bool false
      defaults write "$domain" TrackpadRightClick -bool true
      defaults write "$domain" TrackpadCornerSecondaryClick -int 0
      defaults write "$domain" TrackpadTwoFingerDoubleTapGesture -bool true
    done
    # Natural scrolling off
    defaults write -g com.apple.swipescrolldirection -bool false
    print_ok "Trackpad configured"
  fi

  if section_on mac_battery; then
    print_step "Configuring menu bar battery"
    defaults -currentHost write com.apple.controlcenter BatteryShowPercentage -bool true
    print_ok "Battery percentage enabled"
  fi

  if section_on mac_dock || section_on mac_trackpad || section_on mac_battery; then
    print_step "Restarting Dock and menu bar"
    killall Dock SystemUIServer ControlCenter 2>/dev/null || true
    print_ok "Settings applied (trackpad changes may need a logout)"
  fi
}
