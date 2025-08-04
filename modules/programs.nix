{
  lib,
  config,
  pkgs,
  hyprland,
  ...
}: {
  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  ######################
  ### Virtualisation ###
  ######################

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # Docker
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
}
