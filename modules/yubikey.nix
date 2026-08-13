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

  environment.etc."u2f_keys".text = ''
    dhain:JuvH/7IaeH77/EWp12GGqj2VHiundRMaq2bcdF9McVV2sef88Yr/QTa9V0oVmGEvKPAehXcr2jaA63HrZ54hVA==,Z+zh8nH2i3RLxUlZroFORirSuzuuIlTJs8ZTziHgk1ZqiZct2yHrDkwllnkztI1QG6NIAXrbaCAhPltVrJsetg==,es256,+presence:IDTGNGrOWYdWGalZ4oa/WonNTgMU8Dg9tGYWlIs6NVTbrN+d+iiBRtBU5In22P+GfniruyH1YALiefVxA/w42A==,f+cAx8cra16RaWzcO0QbCUPF3erBozQJnmtLKaYGCMDIMOspIuePIt7kr0B7k3GCM5f9Wu824PFPeAN3QLzGNg==,es256,+presence
  '';
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
