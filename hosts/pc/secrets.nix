{config, ...}: {
  age = {
    identityPaths = [
      "/home/${config.user.username}/.ssh/d-hain"
    ];

    secrets = {
      syncthing-key = {
        file = ../../secrets/syncthing-key.age;
        owner = config.user.username;
        group = "users";
      };
      syncthing-cert = {
        file = ../../secrets/syncthing-cert.age;
        owner = config.user.username;
        group = "users";
      };
    };
  };
}
