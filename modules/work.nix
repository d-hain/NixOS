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
    configFile = "${config.services.syncthing.settings.folders.Sync.path}/Work/WireGuard.conf";
    autostart = false;
  };
}
