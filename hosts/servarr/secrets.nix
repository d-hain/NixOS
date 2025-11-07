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
      wg-server-private-key = {
        file = ../../secrets/wg_server_private_key.age;
        owner = "doce";
        group = "users";
      };
      forgejo-secret-key = {
        file = ../../secrets/forgejo_secret_key.age;
        owner = "doce";
        group = "users";
      };
      forgejo-internal-token = {
        file = ../../secrets/forgejo_internal_token.age;
        owner = "doce";
        group = "users";
      };
      forgejo-oauth-jwt-secret = {
        file = ../../secrets/forgejo_oauth_jwt_secret.age;
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
