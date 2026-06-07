{config, ...}: {
  age = {
    identityPaths = [
      "/home/${config.user.username}/.ssh/laptop"
    ];

    # secrets = {};
  };
}
