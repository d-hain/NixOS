let
  servarr = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDdwRs0RnfJSx6lGDrb5R3SMLGLlOn6aFAsg+RsJvxQv root@servarr";
  pc = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHHIhgc8gF8ut3JW2NpIIzbH4NcRUCf1tIhKneXEMSyq root@doce-pc";
  laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMkcDoB9ljtm9nAx750wz+ltBsbj7Rg5Cg2YkCIN2UjR root@portable";
  masterkey = "age1zgh9vkkmp6uv8jn4k6lvwur4z3k9yql743j6f0m9u8f9a5wc2dfscfs909";
in {
  "ddclient-secrets.age".publicKeys = [
    servarr
    masterkey
  ];
  "caddy_root_key.age".publicKeys = [
    servarr
    masterkey
  ];
  "synology-rsync-backup-pwd.age".publicKeys = [
    servarr
    masterkey
  ];

  #################
  ### Syncthing ###
  #################

  "servarr-syncthing-cert.age".publicKeys = [
    servarr
    masterkey
  ];
  "servarr-syncthing-key.age".publicKeys = [
    servarr
    masterkey
  ];
  "pc-syncthing-cert.age".publicKeys = [
    pc
    masterkey
  ];
  "pc-syncthing-key.age".publicKeys = [
    pc
    masterkey
  ];
  "laptop-syncthing-cert.age".publicKeys = [
    laptop
    masterkey
  ];
  "laptop-syncthing-key.age".publicKeys = [
    laptop
    masterkey
  ];
}
