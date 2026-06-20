let
  servarr = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDdwRs0RnfJSx6lGDrb5R3SMLGLlOn6aFAsg+RsJvxQv root@servarr";
  pc = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHHIhgc8gF8ut3JW2NpIIzbH4NcRUCf1tIhKneXEMSyq root@doce-pc";
  laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMkcDoB9ljtm9nAx750wz+ltBsbj7Rg5Cg2YkCIN2UjR root@portable";
  d-hain = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILExjAbpsovl1IAt/cgGo1NiQfe0rYOdkjPZ+yqPfLc5 d.hain@gmx.at";
in {
  "homarr.age".publicKeys = [
    servarr
    d-hain
  ];
  "ddclient-secrets.age".publicKeys = [
    servarr
    d-hain
  ];
  "caddy_root_key.age".publicKeys = [
    servarr
    d-hain
  ];
  "synology-rsync-backup-pwd.age".publicKeys = [
    servarr
    d-hain
  ];

  #############################################

  "servarr-syncthing-cert.age".publicKeys = [
    servarr
    d-hain
  ];
  "servarr-syncthing-key.age".publicKeys = [
    servarr
    d-hain
  ];
  "pc-syncthing-cert.age".publicKeys = [
    pc
    d-hain
  ];
  "pc-syncthing-key.age".publicKeys = [
    pc
    d-hain
  ];
  "laptop-syncthing-cert.age".publicKeys = [
    laptop
    d-hain
  ];
  "laptop-syncthing-key.age".publicKeys = [
    laptop
    d-hain
  ];
}
