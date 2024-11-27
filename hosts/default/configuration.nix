# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  imports = [
    ./hardware-configuration.nix
  ];

  ##################
  ### Nix Config ###
  ##################

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Allow Steam Unfree Package
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-original"
      "steam-run"
      "spotify"
      "synology-drive-client"
    ];

  ################################
  ### Hardware Stuff / Booting ###
  ################################

  # Enable Bluetooth
  hardware.bluetooth.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;
  environment.etc = {
    "libinput/local-overrides.quirks".text = ''
      [DisableThatShitHighResolution]
      MatchName=*
      AttrEventCode=-REL_WHEEL_HI_RES;-REL_HWHEEL_HI_RES;
    '';
  };

  # Graphics Stuff - https://nixos.wiki/wiki/AMD_GPU
  hardware.amdgpu.initrd.enable = true;
  boot.initrd.kernelModules = ["amdgpu"];
  boot.kernelParams = [
    "video=DP-2:2560x1440@165"
    "video=DP-3:1920x1080@60"
  ];
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];
  hardware.opengl = {
    # WARN: Will be changed to "hardware.graphics" after NixOS 24.11
    enable = true;

    extraPackages = [
      pkgs.amdvlk
      pkgs.rocmPackages.clr.icd
    ];

    # 32bit Support (eg. Steam)
    driSupport32Bit = true; # WARN: Will soon be changed to "enable32Bit"
    extraPackages32 = [pkgs.driversi686Linux.amdvlk];
  };
  services.xserver.videoDrivers = ["amdgpu"]; # Amazing naming. This is for Xorg and Wayland

  ###################
  ### User Config ###
  ###################

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dhain = {
    isNormalUser = true;
    extraGroups = [
      "wheel"     # Enable ‘sudo’ for the user
      "libvirtd"  # Virtualisation using libvirt
    ];

    shell = pkgs.zsh;

    packages = with pkgs; [
      #################
      ### Utilities ###
      #################

      gcc14
      clang_18
      eza
      sl
      ripgrep
      fastfetch
      btop
      stow
      killall
      gamescope
      gnumake
      # (nearly) Up to date Odin compiler
      (pkgs-unstable.odin)

      # Terminal Programs
      wezterm
      neovim
      kakoune

      #######################
      ### "Desktop" Stuff ###
      #######################

      wofi
      waybar
      flameshot
      (pkgs-unstable.hyprshot)
      pavucontrol
      # Bluetooth GUI (doesn't work but makes it work) see: 
      # https://github.com/bluez/bluez/issues/673#issuecomment-1849132576
      # https://wiki.nixos.org/wiki/Bluetooth
      blueman # basically the same as `services.blueman.enable = true;`
      gnome.nautilus
      xorg.xrandr

      # Clipboard
      wl-clipboard
      cliphist

      # Cursor theme
      hyprcursor
      banana-cursor
      glib

      #######################
      ### Normal Programs ###
      #######################

      firefox
      brave
      ungoogled-chromium
      vesktop
      gimp
      anki
      spotify
      synology-drive-client

      # Libreoffice + Spellchecking
      libreoffice-qt6-fresh
      hunspell
      hunspellDicts.de_AT
      hunspellDicts.en_US

      #############
      ### Games ###
      #############

      # Minecraft
      prismlauncher
    ];
  };

  ################
  ### Programs ###
  ################

  # Greeter
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        user = "greeter";
      };
    };
  };

  # Shell
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    ohMyZsh = {
      enable = true;
      theme = "strug";
    };

    shellInit = "clear";

    shellAliases = {
      cls = "clear";
      csl = "sl";
      ls = "eza";
      ll = "eza -la --icons";
      cdp = "cd ~/NAS-David/Programming/";
      cdd = "cd ~/Downloads/";
      enc = "nvim ~/dotfiles/.config/nvim/";
      enx = "nvim ~/dotfiles/nixos/";
      enxc = "nvim ~/dotfiles/nixos/hosts/default/configuration.nix";
      ehc = "nvim ~/dotfiles/.config/hypr/hyprland.conf";
    };
  };

  # Window Manager
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  programs.hyprlock.enable = true;

  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  # Virtualisation
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  ###############################
  ### System-wide environment ###
  ###############################

  networking.hostName = "doce-pc"; # Define your hostname.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Vienna";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = lib.mkDefault {
    font = "Lat2-Terminus16";
    keyMap = "de";
    useXkbConfig = true; # use xkb.options in tty.
  };

  fonts.packages = with pkgs; [
    # Japanese fonts
    ipafont
    kochi-substitute

    jetbrains-mono
    (nerdfonts.override {fonts = ["JetBrainsMono"];})
  ];

  # Hint to Electron Apps to use Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  # Default editor
  environment.variables.EDITOR = "vim";

  # System-wide packages
  environment.systemPackages = with pkgs; [
    tree
    wget
    unzip
    vim
    git
  ];

  # Enable sound.
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  #############################
  ### "DO NOT CHANGE"-stuff ###
  #############################

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # NOTE: Does not work with flakes
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
    }
