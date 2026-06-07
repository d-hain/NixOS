{
  config,
  pkgs,
  ...
}: {
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    key = config.age.secrets.syncthing-key.path;
    cert = config.age.secrets.syncthing-cert.path;

    settings = {
      devices = {
        pc = {id = "XKPEYHH-5YQBG6S-OR6E6P4-5ZJUXEE-4TOPIIW-FY3JNZO-WPDIGWP-BQMWEAP";};
        # TODO: laptop & server
        #     laptop = { id = "sameg"; };
        #     servarr = { id = "sameg"; };
      };

      folders = {
        Sync = {
          path = "/home/${config.user.username}/Sync";
          # TODO: laptop & server
          devices = ["pc"]; # "laptop" "servarr" ];
        };
      };
    };
  };
}
