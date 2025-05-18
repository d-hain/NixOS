# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./qbittorrent.nix
  ];

  ##################
  ### Nix Config ###
  ##################

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 99;
    };
    efi.canTouchEfiVariables = true;
  };

  networking.hostName = "server"; # Define your hostname.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Vienna";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = lib.mkDefault {
    font = "Lat2-Terminus16";
    keyMap = "de";
  };

  ##################
  ### User Stuff ###
  ##################

  # To make SSH work with any terminal (including ghostty)
  environment.variables.TERM = "xterm-256color";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.doce = {
    isNormalUser = true;
    extraGroups = ["wheel"]; # Enable ‘sudo’ for the user.

    packages = with pkgs; [
      stow
    ];
  };

  # Shell
  programs.bash = {
    shellAliases = {
      cls = "clear";
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    unzip
    vim
    git
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;

    # Require ssh key to authenticate
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    settings.PermitRootLogin = "no";
  };

  ##################
  ### Home Media ###
  ##################

  # Media group for all media services
  users.groups.media = {};

  services.jackett = {
    enable = true;
    openFirewall = true;
    dataDir = "/media/jackett/config";
  };

  services.qbittorrent = {
    enable = true;
    openFirewall = true;
    group = "media";
    profileDir = "/media/qbittorrent";

    serverConfig = {
      LegalNotice.Accepted = true;
      Preferences = {
        WebUI = {
          Username = "doce";
          Password_PBKDF2 = "@ByteArray(kamRomhFGYgDZ522gepLyw==:iW6xBEfpcJ2GRqOHtqAGFsIZLKwJxtc4YKieIK8rCk0yzIe7aVRzaIVuKFLS4KWa5UPI8L7RHcrwTXTUcLaZMQ==)";
        };
        General.Locale = "en";
      };
      AutoRun = {
        enabled = true;
        program = "chmod -R 755 %F";
        OnTorrentAdded = {
          Enabled = true;
          Program = "chmod -R 755 %F";
        };
      };
      BitTorrent = {
        Session = {
          Preallocation = true;
          DisableAutoTMMByDefault = false;
          DisableAutoTMMTriggers = {
            DefaultSavePathChanged = false;
            CategorySavePathChanged = false;
          };

          BTProtocol = "TCP";
          UseAlternativeGlobalSpeedLimit = true;
          AlternativeGlobalDLSpeedLimit = 40000;
          AlternativeGlobalULSpeedLimit = 10000;
          BandwidthSchedulerEnabled = true;

          QueueingSystemEnabled = true;

          # No idea what these three do?!
          AddTorrentStopped = false;
          ExcludedFileNames = "";
          ShareLimitAction = "Stop";
        };
        Core.AutoDeleteAddedTorrentFile = "IfAdded";
      };
    };
  };

  services.radarr = {
    enable = true;
    openFirewall = true;
    group = "media";
    dataDir = "/media/radarr/config";
  };

  # WARN: .NET 6 is EOL and should not be used. If Sonarr V5 is out this should be removed!
  nixpkgs.config.permittedInsecurePackages = [
    "dotnet-sdk-6.0.428"
    "aspnetcore-runtime-6.0.36"
  ];
  services.sonarr = {
    enable = true;
    openFirewall = true;
    group = "media";
    dataDir = "/media/sonarr/config";
  };

  services.jellyfin = {
    enable = true;
    openFirewall = true;
    group = "media";
    dataDir = "/media/jellyfin";
  };

  services.jellyseerr = {
    enable = true;
    openFirewall = true;
  };

  systemd.services.jellyseerr-restarter = {
    enable = true;
    description = "Restarts Jellyseerr on startup as that fixes it not loading anything and not recognizing anything for whatever reason.";
    wantedBy = ["default.target"];
    after = ["jellyseerr.service"];
    script = ''
      sleep 10
      systemctl restart jellyseerr.service
    '';
  };

  #############################
  ### "DO NOT CHANGE"-stuff ###
  #############################

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # NOTE: Does not work with flakes
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?
}
