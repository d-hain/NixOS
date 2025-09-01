{pkgs, ...}: {
  # Greeter
  services.greetd = {
    enable = true;

    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd Hyprland";
        user = "greeter";
      };
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  # Autodiscovery of network printers
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Enable sound.
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Automount USB devices
  services.udisks2.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}
