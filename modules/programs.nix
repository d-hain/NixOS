{
  lib,
  config,
  pkgs,
  ...
}: {
  # Setup SSH
  programs.ssh = {
    extraConfig = /* sshconfig */ ''
      Host pub.colonq.computer
          HostName pub.colonq.computer
          User doce
          PreferredAuthentications publickey
          IdentityFile ~/.ssh/d-hain

      Host doceys.computer
          HostName doceys.computer
          User doce
          PreferredAuthentications publickey
          IdentityFile ~/.ssh/d-hain
          LocalForward 8096 127.0.0.1:8096 # Jellyfin
          LocalForward 8989 127.0.0.1:8989 # Sonarr

      Host codeberg
          HostName codeberg.org
          User git
          PreferredAuthentications publickey
          IdentityFile ~/.ssh/d-hain

      Host github
          HostName github.com
          User git
          PreferredAuthentications publickey
          IdentityFile ~/.ssh/d-hain
    '';
  };

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
}
