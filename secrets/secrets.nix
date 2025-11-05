let
  servarr = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBDTHRSi4TtfoeatyB1778beVESIDpOpNtwI6g+uAP7+ servarr";
  d-hain = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILExjAbpsovl1IAt/cgGo1NiQfe0rYOdkjPZ+yqPfLc5 d.hain@gmx.at";
in {
  "homarr.age".publicKeys = [servarr d-hain];
  "forgejo_secret_key.age".publicKeys = [servarr d-hain];
  "forgejo_internal_token.age".publicKeys = [servarr d-hain];
  "forgejo_oauth_jwt_secret.age".publicKeys = [servarr d-hain];
  "doceys.computer_ddns_config.age".publicKeys = [servarr d-hain];
}
