{
  lib,
  pkgs,
  ...
}: {
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Vienna";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = lib.mkDefault {
    font = "Lat2-Terminus16";
    keyMap = "de";
  };

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
