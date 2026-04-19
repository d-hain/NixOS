{...}: {
  age = {
    identityPaths = [
      "/home/doce/.ssh/servarr"
    ];

    secrets = {
      homarr = {
        file = ../../secrets/homarr.age;
        owner = "doce";
        group = "users";
      };
      radicle-servarr-private-key = {
        file = ../../secrets/radicle-servarr-private-key.age;
        owner = "doce";
        group = "users";
      };
      ddclient-secrets = {
        file = ../../secrets/ddclient-secrets.age;
        owner = "doce";
        group = "users";
      };
      caddy_root_key = {
        file = ../../secrets/caddy_root_key.age;
        owner = "caddy";
        group = "caddy";
        mode = "0400";
      };
    };
  };
}
