{
  lib,
  config,
  options,
  pkgs,
  fuzzel-pass,
  helix-notes,
  nix-wrapper-modules,
  ...
}: let
  cfg = config.user;
in {
  options.user = {
    username = lib.mkOption {type = lib.types.str;};
    groups = lib.mkOption {type = lib.types.listOf lib.types.str;};
    packages = lib.mkOption {type = lib.types.listOf lib.types.package;};
  };

  config.user = {
    username = lib.mkDefault "dhain";
    groups = [
      "wheel" # Enable ‘sudo’ for the user
      "libvirtd" # Virtualisation using libvirt
      "docker" # I hate docker with a passion
      "wireshark" # Capture all interfaces without superuser priviledges
    ];

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
      gnumake
      odin # (nearly) Up to date Odin compiler
      rustup
      python3

      # Terminal Programs
      ghostty
      kdePackages.konsole # Fallback terminal
      (nix-wrapper-modules.lib.evalPackage [
        ./nvim.nix
        {inherit pkgs;}
      ])
      typst
      ffmpeg
      imagemagick
      sendme # Ultimate magic and just the best thing ever

      #######################
      ### "Desktop" Stuff ###
      #######################

      fuzzel
      rofimoji # also works with fuzzel
      waybar
      hyprshot
      hyprsunset
      hyprlock
      hyprshutdown
      brightnessctl
      pavucontrol
      # Bluetooth GUI (doesn't work but makes it work) see:
      # https://github.com/bluez/bluez/issues/673#issuecomment-1849132576
      # https://wiki.nixos.org/wiki/Bluetooth
      blueman # basically the same as `services.blueman.enable = true;`
      # Dolphin with Wayland and SVG Icon support
      kdePackages.qtwayland
      kdePackages.qtsvg
      kdePackages.dolphin

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
      google-chrome
      ungoogled-chromium
      vesktop
      gimp3
      anki
      synology-drive-client
      mpv
      spotify
      libreoffice-fresh
      thunderbird
      wireshark
      kdePackages.kdenlive
      # (helix-notes.packages.${pkgs.stdenv.hostPlatform.system}.default)

      # Password Store
      # only for importing from SafeInCloud
      # (pkgs.pass.withExtensions (p: [p.pass-import]))
      pass
      (fuzzel-pass.packages.${pkgs.stdenv.hostPlatform.system}.default)

      # Minecraft
      prismlauncher
      # Flatpak (only for Hytale)
      flatpak
    ];
  };
}
