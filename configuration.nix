{ config, pkgs, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      inputs.crossmacro.nixosModules.default
    ];

  # Docker configuration
  virtualisation.docker = {
    enable = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable NFS kernel modules (nfs/nfs4) and rpcbind service (required for NFS client).
  boot.supportedFilesystems = [ "nfs" "nfs4" ];
  services.rpcbind.enable = true;

  fileSystems."/mnt/MJELDE-NAS" = {
    device = "192.168.1.53:/volume1/Media";
    fsType = "nfs";
    options = [
      "nfsvers=4"
      "x-systemd.automount"
      "noauto"
      "rw"
      "x-systemd.idle-timeout=60"
      "noatime"
      "anonuid=1000"
    ];
  };

  # Network and defaults
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.xserver.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.displayManager.sddm = {
    enable = true;  # Ensure SDDM is enabled
    settings = {
      General = {
        Numlock = "on";  # Enable NumLock in SDDM greeter
      };
    };
  };

  # Make it so that the autoLogin happens for my default account.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "reasel";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Define a user account.
  users.users.reasel = {
    isNormalUser = true;
    description = "Tanner Mjelde";
    extraGroups = [ "networkmanager" "wheel" "docker" "cdrom" ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.graphics  = {
    enable = true;
  };

  hardware.bluetooth.enable = true;

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.production;
    modesetting.enable = true;
    open = true;
    powerManagement.enable = false;
    nvidiaSettings = true;
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  programs.tmux = {
    enable = true;
    extraConfig = ''
      set -g mouse on
    '';
  };

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    # dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    gamescopeSession.enable = true;
  };

  programs.gamescope.enable = true;
  programs.gamemode.enable = true;

  environment.systemPackages = with pkgs; [
      # Gaming Stuff
      heroic bolt-launcher prismlauncher
      protonup-ng protontricks wine winetricks gamemode

      # Comms and Media
      discord
      spotify
      signal-desktop
      easyeffects

      # Utility
      obsidian
      opencode
      alacritty
      obs-studio
      ffmpeg
      vlc
      kdePackages.kcalc
      vscode
      teams-for-linux
      zoom-us
      makemkv
      libreoffice-qt-fresh
      calibre
      conky
      losslesscut-bin

      # CLI Tools
      pciutils
      yad
      zenity
      htop
      zsh
      git
      unzip
      tldr
      scrcpy

      # Dev things?
      cargo
      nodejs
      python313
      docker
      docker-compose
      chromium

  ];


  nixpkgs.overlays = [ inputs.bakkesmod-nix.overlays.default ];

   # Services
  services = {
    # Enable flatpak support
    flatpak = {
      enable = true;
    };

  };

  # ZSH Configuration
  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [ "git" "docker" "sudo" "kubectl" ];
      theme = "robbyrussell";
    };
  };

  programs.crossmacro = {
    enable = true;
    users = [ "reasel" ];  # Add users who should access CrossMacro
  };

  # Sets ZSH as default shell
  users.defaultUserShell = pkgs.zsh;
  users.users.root.shell = pkgs.zsh;

  boot.kernelModules = [ "uinput" "sg" ];

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  system.stateVersion = "25.11";
}


