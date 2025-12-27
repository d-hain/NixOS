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
      doceys-computer-ddns-config = {
        file = ../../secrets/doceys.computer_ddns_config.age;
        owner = "doce";
        group = "users";
      };
    };
  };
}
