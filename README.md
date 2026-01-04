# NixOS Configuration

This repository contains the NixOS configuration for managing a desktop system using Nix Flakes. It includes configurations for system services, user packages, and Home Manager settings for the user "reasel", including BakkesMod setup for Rocket League.

## Flake Inputs

- `nixpkgs`: Unstable version of Nixpkgs
- `home-manager`: User environment management
- `bakkesmod-nix`: BakkesMod plugin management for Rocket League

## Rebuilding NixOS

To update flake inputs and rebuild the system:

```bash
# Rebuild and switch to the new configuration
sudo nixos-rebuild switch --flake ~/nixos
```

To check the configuration for syntax errors:

```bash
sudo nixos-rebuild dry-activate --flake ~/nixos
```

## Files Overview

- `flake.nix`: Main flake definition with inputs and outputs
- `configuration.nix`: NixOS system configuration
- `hardware-configuration.nix`: Auto-generated hardware configuration
