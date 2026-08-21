{pkgs, ...}: {
  user.packages = with pkgs; [
    yubikey-manager # ykman cli
    paperkey # paper backup for the worst-case scenario
  ];

  # Smartcard Daemon
  services.pcscd.enable = true;
  services.udev.packages = with pkgs; [
    libfido2
    yubikey-manager
  ];

  security.pam = {
    # FIDO2 login
    u2f = {
      enable = true;
      control = "sufficient"; # Password or YubiKey
      settings = {
        cue = true;
        authfile = "/etc/u2f_keys";
      };
    };

    services.login.u2f.enable = true;
    services.greetd.u2f.enable = true;
    services.su.u2f.enable = true;
    services.sudo.u2f.enable = true;
  };
}
