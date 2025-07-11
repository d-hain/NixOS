{
  pkgs,
  hyprland,
  ...
}: let
  hypr-unstable = hyprland.inputs.nixpkgs.legacyPackages.${pkgs.system};
in {
  # Enable bluetooth
  hardware.bluetooth.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 99;
    };
    efi.canTouchEfiVariables = true;
  };

  services.libinput.enable = true;
  environment.etc = {
    "libinput/local-overrides.quirks".text = ''
      [DisableThatShitHighResolution]
      MatchName=*
      AttrEventCode=-REL_WHEEL_HI_RES;-REL_HWHEEL_HI_RES;
    '';
  };

  # Graphics Stuff - https://nixos.wiki/wiki/AMD_GPU
  hardware.amdgpu = {
    initrd.enable = true;
    opencl.enable = true;
  };
  boot.initrd.kernelModules = ["amdgpu"];
  boot.kernelParams = [
    "video=DP-2:2560x1440@165"
    "video=DP-3:1920x1080@60"
  ];
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];
  hardware.graphics = {
    enable = true;

    extraPackages = [
      pkgs.amdvlk
      pkgs.rocmPackages.clr.icd
    ];

    # 32bit Support (eg. Steam)
    enable32Bit = true;
    extraPackages32 = [pkgs.driversi686Linux.amdvlk];

    package = hypr-unstable.mesa;
    package32 = hypr-unstable.pkgsi686Linux.mesa;
  };

  services.xserver.videoDrivers = ["amdgpu"]; # Amazing naming. This is for Xorg and Wayland
}
