{pkgs, ...}: {
  # Start Hyprsunset at 18:00:00 every day and turn it off at 8:00:00
  systemd.user.services.hyprsunset = {
    enable = true;
    wantedBy = ["default.target"];
    description = "Starts Hyprsunset";
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.hyprsunset}/bin/hyprsunset -t 5555";
    };
  };
  systemd.user.timers.hyprsunset-evening = {
    wantedBy = ["timers.target"];
    after = ["hyprsunset-morning.service"];
    timerConfig = {
      OnCalendar = "*-*-* 18:00:00";
      Persistent = true;
      Unit = "hyprsunset.service";
    };
  };
  systemd.user.services.hyprsunset-off = {
    description = "Stops 'hyprsunset.service'";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "systemctl --user stop hyprsunset.service";
    };
  };
  systemd.user.timers.hyprsunset-morning = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "*-*-* 8:00:00";
      Persistent = true;
      Unit = "hyprsunset-off.service";
    };
  };
}
