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
      doceys-computer-ddns-config = {
        file = ../../secrets/doceys.computer_ddns_config.age;
        owner = "doce";
        group = "users";
      };
    };
  };
}
