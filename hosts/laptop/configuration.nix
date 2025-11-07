# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./secrets.nix
    ../../modules/nix.nix
    ../../modules/hardware-stuff.nix
    ../../modules/graphics.nix
    ../../modules/environment.nix
    ../../modules/user.nix
    ../../modules/shell.nix
    ../../modules/programs.nix
    ../../modules/hyprsunset.nix
    ../../modules/services.nix
    ../../modules/japanese.nix
    ../../modules/work.nix
  ];

  # Allow Unfree Packages explicitly
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-unwrapped"
      "steam-original"
      "steam-run"

      "google-chrome"
      "spotify"
      "synology-drive-client"
    ];

  networking.hostName = "portable"; # Define your hostname.

  # Wireguard to Server
  networking.wg-quick.interfaces.server = {
    address = ["10.0.0.2/24"];
    privateKeyFile = config.age.secrets.wg-laptop-private-key.path;
    peers = [
      { # Server
        publicKey = "pwps2Hs9J8PIVqLrtIn6lowZn657e6onLptaUm4jaAU=";
        allowedIPs = ["10.0.0.0/24"];
        endpoint = "doceys.computer:51820";
        persistentKeepalive = 25;
      }
    ];
  };

  user = {
    enable = true;
    username = "dhain";

    # extra :packages
    packages = with pkgs; [
    ];
  };

  programs.zsh.shellAliases.enxc = "cd ~/NixOS/ && nvim ./hosts/laptop/configuration.nix";

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
  system.stateVersion = "25.05"; # Did you read the comment?
}
