{...}: {
  age = {
    identityPaths = [
      "/home/dhain/.ssh/d-hain"
    ];

    secrets = {
      wg-laptop-private-key = {
        file = ../../secrets/wg_laptop_private_key.age;
        owner = "dhain";
        group = "users";
      };
    };
  };
}
