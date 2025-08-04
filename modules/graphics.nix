{
  pkgs,
  hyprland,
  ...
}: let
  hypr-unstable = hyprland.inputs.nixpkgs.legacyPackages.${pkgs.system};
in {
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

  # Window Manager
  nix.settings = {
    # Enable Hyprland Cachix for installing via the Flake
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;

    package = hyprland.packages.${pkgs.system}.hyprland;
    portalPackage = hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
  };
  xdg.portal.extraPortals = [pkgs.kdePackages.xdg-desktop-portal-kde];

  # Hint to Electron Apps to use Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
