{config, ...}: {
  age = {
    identityPaths = [
      "/etc/ssh/ssh_host_ed25519_key"
    ];

    secrets = {
      homarr = {
        file = ../../secrets/homarr.age;
        owner = config.user.username;
        group = "users";
      };
      ddclient-secrets = {
        file = ../../secrets/ddclient-secrets.age;
        owner = config.user.username;
        group = "users";
      };
      caddy_root_key = {
        file = ../../secrets/caddy_root_key.age;
        owner = config.services.caddy.user;
        group = config.services.caddy.group;
        mode = "0400";
      };
      synology-rsync-backup-pwd = {
        file = ../../secrets/synology-rsync-backup-pwd.age;
        owner = config.user.username;
        group = "users";
      };
    };
  };
}
