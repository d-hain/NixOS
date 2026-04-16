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
    };
  };
}
