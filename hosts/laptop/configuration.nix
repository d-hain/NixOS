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
    ../../modules/git.nix
    ../../modules/environment.nix
    ../../modules/user.nix
    ../../modules/shell.nix
    ../../modules/programs.nix
    ../../modules/syncthing.nix
    ../../modules/hyprsunset.nix
    ../../modules/services.nix
    ../../modules/japanese.nix
    ../../modules/jai.nix
    ../../modules/yubikey.nix
    ./dotfiles.nix
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
    ];

  networking.hostName = "portable"; # Define your hostname.

  users.users.${config.user.username} = {
    isNormalUser = true;
    extraGroups = config.user.groups;
    shell = pkgs.zsh;

    # extra :packages
    packages = with pkgs;
      [
        hyprpaper
      ]
      ++ config.user.packages;
  };

  # pamu2fcfg
  environment.etc."u2f_keys".text = ''
    dhain:qFppPmUTaYX4ib++h6i20Ut8V51nerlK+7ANgR0kFAqiMMKrH5Uq/5v143cdPa8g6GliZYseEruaaUPX2VL+Qg==,dNd1wMZg/cymLKnveXVUvS3YIO/+7+xPFKR7az2Bo9fOZGBSY4KljXPTmG+PtEF30x4il5zyPf57/a2VImVyDw==,es256,+presence:xrNGyr2tyjZDFUfBia9sJS4B8kW2jZjjrry5hRPvmyi2R3uCassBWZN4KNYsagaWxQluG1ShKt3MDvIT5CRpJA==,wzppaesYn/CUqftuMrHmJKNZtJ/qAqDzSPbTgsit1tk/ecafQdOlKVw4RcZvhnG+u6ajfOgohzGRfyQQvH+2NA==,es256,+presence
  '';

  programs.git.config = {
    user.signingkey = "57C33664F3FFF98281DE220E4AF40104E9BBA1FB";
    commit.gpgsign = true;
  };

  programs.zsh.shellAliases.enxc = "cd ~/NixOS/ && nvim ./hosts/laptop/configuration.nix";

  syncthing = {
    enable = true;
    peers = {
      pc = {id = "WRYBK4C-BMRSC7C-5CYSGDU-PE3H2DK-EVFFX7R-UF3UOFB-RMKJNXM-OLRGBQR";};
      servarr = {id = "T6Q4C2E-QK3LHT6-BIVW26X-FBYO5YC-YE4ZKLQ-RTVNSXX-3LRPA4A-ULSFJQH";};
    };
    keyFile = ../../secrets/laptop-syncthing-key.age;
    certFile = ../../secrets/laptop-syncthing-cert.age;
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
  system.stateVersion = "25.05"; # Did you read the comment?
}
