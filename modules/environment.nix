{
  lib,
  config,
  pkgs,
  ...
}: {
  # FUCK NANO
  programs.nano.enable = false;

  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Vienna";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = lib.mkDefault {
    font = "Lat2-Terminus16";
    keyMap = "de";
  };

  fonts.packages = with pkgs; [
    font-awesome
    jetbrains-mono
    nerd-fonts.jetbrains-mono

    # Japanese
    ipafont
    kochi-substitute
    # Korean
    baekmuk-ttf
  ];

  # Environment variables
  environment.variables = {
    EDITOR = "nvim";
    TERMINAL = "ghostty";
  };
  # Flatpak apps (aka Hytale)
  environment.sessionVariables.XDG_DATA_DIRS = [
    "$XDG_DATA_DIRS:/home/${config.user.username}/.local/share/flatpak/exports/share"
  ];

  # System-wide packages
  environment.systemPackages = with pkgs; [
    tree
    wget
    zip
    unzip
    vim
  ];
  # Git
  programs.git = {
    enable = true;
    config = {
      init.defaultBranch = "master";
      pull.ff = "only";
    };
  };
}
