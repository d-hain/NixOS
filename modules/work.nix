{
  config,
  pkgs,
  ...
}: {
  user.packages = with pkgs; [
    kdePackages.krdc
  ];

  # Work Wireguard
  networking.wg-quick.interfaces.work = {
    configFile = "/home/${config.user.username}/NAS-David/Work/WireGuard.conf";
    autostart = false;
  };
}
