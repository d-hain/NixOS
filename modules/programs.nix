{
  lib,
  config,
  pkgs,
  ...
}: {
  # Setup SSH
  programs.ssh = {
    startAgent = true;
    enableAskPassword = true;
    askPassword = "${pkgs.lxqt.lxqt-openssh-askpass}/bin/lxqt-openssh-askpass";
    extraConfig =
      # sshconfig
      ''
        Host *
            AddKeysToAgent yes

        Host pub.colonq.computer
            HostName pub.colonq.computer
            User doce
            PreferredAuthentications publickey
            IdentityFile ~/.ssh/d-hain_yubikey1
            IdentityFile ~/.ssh/d-hain_yubikey2

        Host doceys.computer
            HostName doceys.computer
            User doce
            PreferredAuthentications publickey
            ForwardAgent yes
            IdentityFile ~/.ssh/d-hain_yubikey1
            IdentityFile ~/.ssh/d-hain_yubikey2
            # Use with SOCKS v5 enabled in Firefox and set to 127.0.0.1:1080
            DynamicForward 1080

        Host git.doceys.computer
            HostName doceys.computer
            User git
            PreferredAuthentications publickey
            IdentityFile ~/.ssh/d-hain_yubikey1
            IdentityFile ~/.ssh/d-hain_yubikey2

        Host codeberg
            HostName codeberg.org
            User git
            PreferredAuthentications publickey
            IdentityFile ~/.ssh/d-hain_yubikey1
            IdentityFile ~/.ssh/d-hain_yubikey2

        Host github
            HostName github.com
            User git
            PreferredAuthentications publickey
            IdentityFile ~/.ssh/d-hain_yubikey1
            IdentityFile ~/.ssh/d-hain_yubikey2
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

  virtualisation.libvirtd = {
    enable = true;
    qemu.vhostUserPackages = [pkgs.virtiofsd];
  };
  programs.virt-manager.enable = true;
}
