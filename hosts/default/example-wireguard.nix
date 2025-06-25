{
    config,
    pkgs,
    ...
}:
{
    interface-name = {
      autostart = false;

      privateKey = "<PRIVATE_KEY>";
      address = [ "192.168.1.1/24" ];

      peers = [
        {
          publicKey = "<PUBLIC_KEY>";
          presharedKey = "<PRESHARED_KEY>";
          allowedIPs = ["192.168.1.0/24"];
          endpoint = "example.com:12345";
          persistentKeepalive = 25;
        }
      ];
    };
}
