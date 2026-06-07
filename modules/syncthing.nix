{
  config,
  pkgs,
  ...
}: {
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = config.user.username;
    group = "users";
    dataDir = "/home/${config.user.username}/.local/share/syncthing";
    key = config.age.secrets.syncthing-key.path;
    cert = config.age.secrets.syncthing-cert.path;

    settings = {
      devices = {
        pc = {id = "XKPEYHH-5YQBG6S-OR6E6P4-5ZJUXEE-4TOPIIW-FY3JNZO-WPDIGWP-BQMWEAP";};
        laptop = {id = "5TGBSL7-WJBWPYJ-HV2COFK-SR5VC7F-VA47MAA-I3LO4XF-W3E5X5X-KECH4AP";};
        # TODO: server
        #     servarr = { id = "sameg"; };
      };

      folders = {
        Sync = {
          path = "/home/${config.user.username}/Sync";
          # TODO: server
          devices = ["pc" "laptop"];
        };
      };
    };
  };
}
