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
      "nvidia-x11"
      "nvidia-settings"
      "nvidia-kernel-modules"

      "steam"
      "steam-unwrapped"
      "steam-original"
      "steam-run"

      "google-chrome"
      "spotify"
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

  users.users.${config.user.username} = {
    isNormalUser = true;
    extraGroups = config.user.groups;
    shell = pkgs.zsh;

    # extra :packages
    packages = with pkgs;
      [
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
      ]
      ++ config.user.packages;
  };

  # pamu2fcfg
  environment.etc."u2f_keys".text = ''
    dhain:JuvH/7IaeH77/EWp12GGqj2VHiundRMaq2bcdF9McVV2sef88Yr/QTa9V0oVmGEvKPAehXcr2jaA63HrZ54hVA==,Z+zh8nH2i3RLxUlZroFORirSuzuuIlTJs8ZTziHgk1ZqiZct2yHrDkwllnkztI1QG6NIAXrbaCAhPltVrJsetg==,es256,+presence:IDTGNGrOWYdWGalZ4oa/WonNTgMU8Dg9tGYWlIs6NVTbrN+d+iiBRtBU5In22P+GfniruyH1YALiefVxA/w42A==,f+cAx8cra16RaWzcO0QbCUPF3erBozQJnmtLKaYGCMDIMOspIuePIt7kr0B7k3GCM5f9Wu824PFPeAN3QLzGNg==,es256,+presence
  '';

  programs.git.config = {
    user.signingkey = "57C33664F3FFF98281DE220E4AF40104E9BBA1FB";
    commit.gpgsign = true;
  };

  programs.zsh.shellAliases.enxc = "cd ~/NixOS/ && nvim ./hosts/pc/configuration.nix";

  syncthing = {
    enable = true;
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
