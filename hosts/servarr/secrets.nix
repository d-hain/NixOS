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
    };
  };
}
