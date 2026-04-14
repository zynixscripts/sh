#!/usr/bin/env bash
set -euo pipefail

sudo pacman -Syu --noconfirm

sudo pacman -S --needed --noconfirm \
  plasma-meta kwin sddm sddm-kcm \
  qt6-wayland egl-wayland wayland wayland-protocols \
  kwayland plasma-wayland-protocols \
  xdg-desktop-portal xdg-desktop-portal-kde \
  pipewire pipewire-pulse wireplumber \
  plasma-nm plasma-pa powerdevil kscreen kscreenlocker \
  bluedevil discover ark \
  fish fastfetch btop neovim git unzip tar zip \
  gvfs gvfs-mtp ntfs-3g exfatprogs \
  noto-fonts noto-fonts-emoji ttf-dejavu ttf-liberation \
  mesa vulkan-radeon lib32-mesa lib32-vulkan-radeon \
  vkd3d wine winetricks \
  tuned irqbalance

sudo systemctl enable sddm
sudo systemctl enable irqbalance

systemctl --user daemon-reexec
systemctl --user enable --now pipewire pipewire-pulse wireplumber || true

if command -v fish >/dev/null 2>&1; then
  chsh -s /usr/bin/fish
fi

sudo reboot now
