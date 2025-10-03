{pkgs, ...}: {
  user.packages = with pkgs; [
    kdePackages.krdc
  ];

  # Work Wireguard
  networking.wg-quick.interfaces.work = {
    configFile = "/home/dhain/NAS-David/Work/WireGuard.conf";
    autostart = false;
  };
}
