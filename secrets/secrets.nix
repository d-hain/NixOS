let
  servarr = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBDTHRSi4TtfoeatyB1778beVESIDpOpNtwI6g+uAP7+ servarr";
  pc = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJtri3LS4mYvOSj+yUGW+jl+NXR5RESaSUZQW4cXAkvR pc";
  # TODO: laptop = "";
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

  "syncthing-cert.age".publicKeys = [
    pc
    # TODO: laptop
    servarr
    d-hain
  ];
  "syncthing-key.age".publicKeys = [
    pc
    # TODO: laptop
    servarr
    d-hain
  ];
}
