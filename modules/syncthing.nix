{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.syncthing;
in {
  options.syncthing = {
    enable = mkEnableOption "Syncthing module";

    peers = mkOption {
      description = "The peers/devices which Syncthing should communicate with.";
      example = {
        laptop = {
          id = "5TGBSL7-WJBWPYJ-HV2COFK-SR5VC7F-VA47MAA-I3LO4XF-W3E5X5X-KECH4AP";
        };
      };
    };
    peers-notes = mkOption {
      description = "The peers ONLY for the Notes folder.";
      default = {
        phone = {
          id = "YFQXO7W-CRPYDBK-BP3WWUK-O7MSZJP-IGC57VW-VRP7BY4-YOPIUCR-RFN3YQG";
        };
      };
    };

    keyFile = mkOption {
      type = types.path;
      description = "Path to the agenix encrypted private key file.";
    };
    certFile = mkOption {
      type = types.path;
      description = "Path to the agenix encrypted private certificate file.";
    };
  };

  config = mkIf cfg.enable {
    age.secrets = {
      syncthing-key = {
        file = cfg.keyFile;
        owner = config.user.username;
        group = "users";
      };
      syncthing-cert = {
        file = cfg.certFile;
        owner = config.user.username;
        group = "users";
      };
    };

    services.syncthing = {
      enable = true;
      openDefaultPorts = true;
      user = config.user.username;
      group = "users";
      dataDir = "/home/${config.user.username}/.local/share/syncthing";
      key = config.age.secrets.syncthing-key.path;
      cert = config.age.secrets.syncthing-cert.path;

      settings = {
        devices = cfg.peers // cfg.peers-notes;

        folders = {
          Sync = {
            path = "/home/${config.user.username}/Sync";
            devices = builtins.attrNames cfg.peers;
          };

          Notes = {
            path = "/home/${config.user.username}/Notes";
            devices = (builtins.attrNames cfg.peers) ++ (builtins.attrNames cfg.peers-notes);
          };
        };
      };
    };

    user.packages = [pkgs.syncthingtray-minimal];
  };
}
