#!/usr/bin/env bash
set -euo pipefail

sudo pacman -Syu --noconfirm

sudo pacman -S --needed --noconfirm \
  firefox chromium discord spotify-launcher zed github-cli gameconqueror kdenlive \
  fish fastfetch btop neovim git unzip tar zip \
  noto-fonts noto-fonts-emoji ttf-dejavu ttf-liberation \
  gvfs gvfs-mtp ntfs-3g exfatprogs \
  mesa vulkan-radeon lib32-mesa lib32-vulkan-radeon vkd3d wine winetricks \
  alacritty

sudo pacman -S --needed --noconfirm \
  plasma-desktop plasma-workspace plasma-wayland-session \
  kwin kwayland plasma-wayland-protocols \
  dolphin konsole kate ark spectacle gwenview \
  sddm sddm-kcm \
  xdg-desktop-portal xdg-desktop-portal-kde \
  pipewire pipewire-pulse wireplumber \
  plasma-nm plasma-pa powerdevil kscreen kscreenlocker bluedevil discover

GPU=$(lspci | grep -E "VGA|3D" | head -n1 | tr '[:upper:]' '[:lower:]')

if echo "$GPU" | grep -qi "amd"; then
  COLOR="BreezeDark"
  CURSOR="Breeze"
elif echo "$GPU" | grep -qi "intel"; then
  COLOR="BreezeLight"
  CURSOR="Breeze_Snow"
elif echo "$GPU" | grep -qi "nvidia"; then
  COLOR="BreezeDark"
  CURSOR="Breeze"
else
  COLOR="BreezeDark"
  CURSOR="Breeze"
fi

mkdir -p ~/.config/kdeglobals.d

cat > ~/.config/kdeglobals.d/gpu-theme.conf <<EOF
[General]
ColorScheme=$COLOR
EOF

kwriteconfig6 --file kdeglobals General ColorScheme "$COLOR" || true
kwriteconfig6 --file kdeglobals Icons breeze-dark || true
kwriteconfig6 --file kdeglobals KDE CursorTheme "$CURSOR" || true

mkdir -p ~/.config/alacritty

cat > ~/.config/alacritty/alacritty.toml <<'EOF'
[env]
TERM = "xterm-256color"
WINIT_X11_SCALE_FACTOR = "1"

[window]
dynamic_padding = true
decorations = "full"
title = "Alacritty@CachyOS"
opacity = 0.8
decorations_theme_variant = "Dark"

[window.dimensions]
columns = 100
lines = 30

[scrolling]
history = 10000
multiplier = 3

[colors.primary]
background = "0x2E3440"
foreground = "0xD8DEE9"

[font]
size = 12

[font.normal]
family = "monospace"
style = "Regular"

[cursor]
style = "Underline"

[general]
live_config_reload = true
EOF

systemctl --user enable pipewire pipewire-pulse wireplumber || true
sudo systemctl enable sddm
sudo systemctl enable irqbalance || true

echo "Setup complete. Reboot recommended."
sudo reboot
