{
  lib,
  pkgs,
  ...
}: {
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Vienna";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      enable = true;
      type = "uim";
      # ibus.engines = with pkgs.ibus-engines; [mozc];
    };
  };
  console = lib.mkDefault {
    font = "Lat2-Terminus16";
    keyMap = "de";
  };

  fonts.packages = with pkgs; [
    font-awesome
    jetbrains-mono
    nerd-fonts.jetbrains-mono

    # Japanese fonts
    ipafont
    kochi-substitute
  ];

  # Environment variables
  environment.variables = {
    EDITOR = "nvim";
    TERMINAL = "ghostty";
  };
  # Hint to Electron Apps to use Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # System-wide packages
  environment.systemPackages = with pkgs; [
    tree
    wget
    zip
    unzip
    vim
    git
  ];
}
