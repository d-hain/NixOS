{pkgs, ...}: {
  # Make Jai work
  services.envfs.enable = true; # envfs fills out local variables
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      zlib
      glibc
      libGL
      libx11
    ];
  };
  # NOTE: straight up stolen from https://github.com/michaelsmiller/millerconfig/blob/7c8da2680f98a86025af9049f23d3ae664d62f50/nixos/configuration.nix#L149
  # nix-ld puts symlinks of libraries we add in the specific folder below.
  # The jai compiler checks /etc/ld.so.conf for where to look for libraries
  # first, so the easiest place to make sure it finds them is to create this file
  environment.etc."ld.so.conf".text = ''
    /run/current-system/sw/share/nix-ld/lib
  '';
}
