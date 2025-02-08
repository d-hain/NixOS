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
  pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
in {
  imports = [
    ./hardware-configuration.nix
  ];

  ##################
  ### Nix Config ###
  ##################

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Allow Unfree Packages explicitly
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "nvidia-x11"
      "nvidia-settings"

      "steam"
      "steam-unwrapped"
      "steam-original"
      "steam-run"

      "discord-canary"
      "spotify"
      "synology-drive-client"
      "osu-lazer-bin"
    ];

  ########################
  ### Network Mounting ###
  ########################

  fileSystems."/home/dhain/NAS-Hain" = {
    device = "192.168.1.22:/volume1/Hain";
    fsType = "nfs";
    options = [
      "nofail" # Don't require to mount for successful boot
    ];
  };

  ################################
  ### Hardware Stuff / Booting ###
  ################################

  # Enable Bluetooth
  hardware.bluetooth.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;
  # Autodiscovery of network printers
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

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
  hardware.amdgpu = {
    initrd.enable = true;
    opencl.enable = true;
  };
  boot.initrd.kernelModules = ["amdgpu"];
  boot.kernelParams = [
    "video=DP-2:2560x1440@165"
    "video=DP-3:1920x1080@60"
  ];
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];
  hardware.graphics = {
    enable = true;

    extraPackages = [
      pkgs.amdvlk
      pkgs.rocmPackages.clr.icd
    ];

    # 32bit Support (eg. Steam)
    enable32Bit = true;
    extraPackages32 = [pkgs.driversi686Linux.amdvlk];
  };
  hardware.nvidia.open = false; # Open source drivers do not support Pascal GPUs
  services.xserver.videoDrivers = ["amdgpu" "nvidia"]; # Amazing naming. This is for Xorg and Wayland

  ###################
  ### User Config ###
  ###################

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dhain = {
    isNormalUser = true;
    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user
      "libvirtd" # Virtualisation using libvirt
    ];

    shell = pkgs.zsh;

    # :packages
    packages = with pkgs; [
      #################
      ### Utilities ###
      #################

      gcc14
      clang_18
      man-pages
      man-pages-posix
      gdb
      eza
      sl
      ripgrep
      fastfetch
      btop
      stow
      gamescope
      gnumake
      # (nearly) Up to date Odin compiler
      (pkgs-unstable.odin)
      rustup

      # Terminal Programs
      wezterm
      (inputs.ghostty.packages.${pkgs.system}.default)
      kakoune
      typst
      tinymist

      # Neovim and LSPs
      neovim
      lua-language-server
      rust-analyzer
      clang-tools
      ols
      glsl_analyzer
      superhtml

      #######################
      ### "Desktop" Stuff ###
      #######################

      opentabletdriver
      wofi
      waybar
      flameshot
      (pkgs-unstable.hyprshot)
      hyprsunset
      pavucontrol
      # Bluetooth GUI (doesn't work but makes it work) see:
      # https://github.com/bluez/bluez/issues/673#issuecomment-1849132576
      # https://wiki.nixos.org/wiki/Bluetooth
      blueman # basically the same as `services.blueman.enable = true;`
      nautilus
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
      discord-canary
      gimp
      anki
      spotify
      synology-drive-client
      mpv
      obs-studio
      blender-hip # "-hip" makes performance on AMD better

      # Password Store
      # only for importing from SafeInCloud
      # (pkgs.pass.withExtensions (p: [p.pass-import]))
      pass
      wofi-pass

      # Libreoffice + Spellchecking
      libreoffice-qt6-fresh
      hunspell
      hunspellDicts.de_AT
      hunspellDicts.en_US

      ################
      ### Libaries ###
      ################

      # Needed for Virt-manager filesystem sharing
      virtiofsd

      # iPhone Mounting
      libimobiledevice
      ifuse

      #############
      ### Games ###
      #############

      osu-lazer-bin

      # Minecraft
      prismlauncher
    ];
  };

  ################
  ### Programs ###
  ################

  # Start Hyprsunset at 18:00:00 every day and turn it off at 8:00:00
  systemd.user.services.hyprsunset = {
    enable = true;
    wantedBy = ["default.target"];
    description = "Starts Hyprsunset";
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.hyprsunset}/bin/hyprsunset -t 5555";
    };
  };
  systemd.user.timers.hyprsunset-evening = {
    wantedBy = ["timers.target"];
    after = ["hyprsunset-morning.service"];
    timerConfig = {
      OnCalendar = "*-*-* 18:00:00";
      Persistent = true;
      Unit = "hyprsunset.service";
    };
  };
  systemd.user.services.hyprsunset-off = {
    description = "Stops 'hyprsunset.service'";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "systemctl --user stop hyprsunset.service";
    };
  };
  systemd.user.timers.hyprsunset-morning = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "*-*-* 8:00:00";
      Persistent = true;
      Unit = "hyprsunset-off.service";
    };
  };

  # Greeter
  services.greetd = {
    enable = true;
    vt = 2;

    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd Hyprland";
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
    };

    promptInit = ''source "/home/dhain/.strug.zsh-theme"'';
    shellInit = "clear";

    shellAliases = {
      cls = "clear";
      csl = "sl";

      ls = "eza";
      ll = "eza -la --icons";
      la = "eza -a";

      cda = "cd ~/NAS-David/anime-manga-notes";
      cdp = "cd ~/NAS-David/Programming/";
      cdd = "cd ~/Downloads/";

      enc = "cd ~/dotfiles/.config/nvim && nvim .";
      enx = "cd ~/dotfiles/nixos/ && nvim .";
      enxc = "cd ~/dotfiles/nixos/ && nvim ./hosts/default/configuration.nix";
      ehc = "cd ~/dotfiles/.config/hypr/ && nvim ./hyprland.conf";

      fastfetch = "fastfetch -c ~/.config/fastfetch/clean.jsonc";
    };
  };
  # environment.home.dhain = {
  #   "/home/dhain/.zshrc".text = ''
  #     eval "$(direnv hook zsh)"
  #   '';
  # };
  programs.direnv.enable = true;

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

  # iPhone Mounting
  services.usbmuxd = {
    enable = true;
    package = pkgs.usbmuxd2;
  };

  ###############################
  ### System-wide environment ###
  ###############################

  networking.hostName = "doce-pc"; # Define your hostname.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Vienna";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5.addons = [pkgs.fcitx5-mozc];
    };
  };
  console = lib.mkDefault {
    font = "Lat2-Terminus16";
    keyMap = "de";
    useXkbConfig = true; # use xkb.options in tty.
  };

  fonts.packages = with pkgs; [
    font-awesome
    jetbrains-mono
    (nerdfonts.override {fonts = ["JetBrainsMono"];})

    # Japanese fonts
    ipafont
    kochi-substitute
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
    killall
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
