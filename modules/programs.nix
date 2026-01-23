{
  lib,
  config,
  pkgs,
  ...
}: {
  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  # Wireshark
  programs.wireshark = {
    enable = true;
  };

  # OBS
  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;

    plugins = with pkgs.obs-studio-plugins; [
      obs-vaapi
      obs-vkcapture
    ];
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
