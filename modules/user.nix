{
  lib,
  config,
  options,
  pkgs,
  fuzzel-pass,
  neovim-nightly-overlay,
  nix-wrapper-modules,
  ...
}: let
  cfg = config.user;

  satty-config = pkgs.writeText "satty-config.toml" /* toml */ ''
    [general]
    app-id = "org.satty.satty"
    disable-notifications = false
    output-filename = ""
    initial-tool = "brush"

    [font]
    family = "JetBrains Mono"
    style = "Medium"

    [color-palette]
    palette = [
      "#ff0000ff",
      "#00ff00ff",
      "#0000ffff",
    ]
  '';
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

      gcc
      clang
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
      wezterm
      kdePackages.konsole # Fallback terminal
      (nix-wrapper-modules.lib.evalPackage [
        ./nvim.nix
        {inherit pkgs;}
        {_module.args.neovim-nightly-overlay = neovim-nightly-overlay;}
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
      hyprsunset
      hyprlock
      hyprshutdown
      brightnessctl
      pavucontrol
      setxkbmap # used to fix XWayland keyboard layout
      # Bluetooth GUI (doesn't work but makes it work) see:
      # https://github.com/bluez/bluez/issues/673#issuecomment-1849132576
      # https://wiki.nixos.org/wiki/Bluetooth
      blueman # basically the same as `services.blueman.enable = true;`
      # Dolphin with Wayland and SVG Icon support
      kdePackages.qtwayland
      kdePackages.qtsvg
      kdePackages.dolphin

      # Screenshots
      grim
      slurp
      (pkgs.writeShellScriptBin "satty" ''
        exec ${satty}/bin/satty --config ${satty-config} "$@"
      '')

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
      mpv
      spotify
      libreoffice
      thunderbird
      wireshark
      kdePackages.kdenlive

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
