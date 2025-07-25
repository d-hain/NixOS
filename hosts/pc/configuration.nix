# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  lib,
  pkgs,
  hyprland,
  ghostty,
  fuzzel-pass,
  ...
}: let
  hypr-unstable = hyprland.inputs.nixpkgs.legacyPackages.${pkgs.system};
in {
  imports = [
    ./hardware-configuration.nix
    ../../modules/nix.nix
    ../../modules/hardware-stuff.nix
    ../../modules/environment.nix
    ../../modules/user.nix
    ../../modules/shell.nix
    ../../modules/programs.nix
    ../../modules/hyprsunset.nix
    ../../modules/services.nix
  ];

  # Allow Unfree Packages explicitly
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "nvidia-x11"
      "nvidia-settings"

      "steam"
      "steam-unwrapped"
      "steam-original"
      "steam-run"

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

  ######################
  ### Hardware Stuff ###
  ######################

  # "amdgpu" is already set in the hardware module
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia.open = false;

  # iPhone Mounting
  services.usbmuxd = {
    enable = true;
    package = pkgs.usbmuxd2;
  };

  ##############
  ### Config ###
  ##############

  networking.hostName = "doce-pc"; # Define your hostname.

  user = {
    enable = true;
    username = "dhain";

    # :packages
    packages = with pkgs; [
      opentabletdriver

      #########################
      ### Terminal programs ###
      #########################

      gamescope

      ############
      ### Apps ###
      ############

      element-desktop
      spotify
      obs-studio
      blender-hip
      kdePackages.krdc

      #############
      ### Games ###
      #############

      osu-lazer-bin
    ];
  };

  # Make Jai work
  services.envfs.enable = true; # envfs fills out local variables
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      zlib
      glibc
      libGL
      xorg.libX11
    ];
  };
  # NOTE: straight up stolen from https://github.com/michaelsmiller/millerconfig/blob/7c8da2680f98a86025af9049f23d3ae664d62f50/nixos/configuration.nix#L149
  # nix-ld puts symlinks of libraries we add in the specific folder below.
  # The jai compiler checks /etc/ld.so.conf for where to look for libraries
  # first, so the easiest place to make sure it finds them is to create this file
  environment.etc."ld.so.conf".text = ''
    /run/current-system/sw/share/nix-ld/lib
  '';

  # Work Wireguard
  networking.wg-quick.interfaces.work = {
    configFile = "/home/dhain/NAS-David/Work/WireGuard.conf";
    autostart = false;
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
