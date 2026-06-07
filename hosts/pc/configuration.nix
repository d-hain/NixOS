# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  lib,
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
    ../../modules/syncthing.nix
    ../../modules/hyprsunset.nix
    ../../modules/services.nix
    ../../modules/japanese.nix
    ../../modules/work.nix
    ../../modules/jai.nix
    ./dotfiles.nix
  ];

  # Allow Unfree Packages explicitly
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "nvidia-x11"
      "nvidia-settings"
      "nvidia-kernel-modules"

      "steam"
      "steam-unwrapped"
      "steam-original"
      "steam-run"

      "google-chrome"
      "spotify"
      "synology-drive-client"
      "osu-lazer-bin"
    ];

  ######################
  ### Hardware Stuff ###
  ######################

  # Graphics Stuff - https://nixos.wiki/wiki/AMD_GPU
  hardware.amdgpu = {
    initrd.enable = true;
    opencl.enable = true;
  };
  boot.initrd.kernelModules = ["amdgpu"];
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

  # NOTE: "amdgpu" is already set in the hardware module
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia.open = false;

  ##############
  ### Config ###
  ##############

  networking.hostName = "doce-pc"; # Define your hostname.

  user = {
    enable = true;
    username = "dhain";

    # extra :packages
    packages = with pkgs; [
      ###############
      ### Drivers ###
      ###############

      opentabletdriver

      ############
      ### Apps ###
      ############

      pkgsRocm.blender

      #############
      ### Games ###
      #############

      gamescope
      osu-lazer-bin
    ];
  };

  programs.zsh.shellAliases.enxc = "cd ~/NixOS/ && nvim ./hosts/pc/configuration.nix";

  syncthing = {
    enable = true;
    deviceId = "XKPEYHH-5YQBG6S-OR6E6P4-5ZJUXEE-4TOPIIW-FY3JNZO-WPDIGWP-BQMWEAP";
    peers = {
      laptop = {id = "5TGBSL7-WJBWPYJ-HV2COFK-SR5VC7F-VA47MAA-I3LO4XF-W3E5X5X-KECH4AP";};
      servarr = {id = "T6Q4C2E-QK3LHT6-BIVW26X-FBYO5YC-YE4ZKLQ-RTVNSXX-3LRPA4A-ULSFJQH";};
    };
    keyFile = ../../secrets/pc-syncthing-key.age;
    certFile = ../../secrets/pc-syncthing-cert.age;
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
