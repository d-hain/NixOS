# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  pkgs,
  config,
  lib,
  ...
}: let
  url-local = "192.168.1.69";
  url = "doceys.computer";
  url-git = "git.doceys.computer";
in {
  imports = [
    ./hardware-configuration.nix
    ./secrets.nix
    ../../modules/nix.nix
    ../../modules/environment.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 15;
    };
    efi.canTouchEfiVariables = true;
  };

  networking.hostName = "servarr"; # Define your hostname.

  ##################
  ### User Stuff ###
  ##################

  environment.variables = {
    # To make SSH work with any terminal (including ghostty)
    TERM = "xterm-256color";
    # Nano is my archenemy
    EDITOR = "vim";
  };

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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;

    openFirewall = true;
    # Require ssh key to authenticate
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    settings.PermitRootLogin = "no";
  };

  # DDNS
  services.ddns-updater = {
    enable = true;
    environment.CONFIG_FILEPATH = "%d/config";
  };
  # Thanks to https://github.com/joshuakb2/configuration.nix/blob/0284721889b4121f6cc361f8617eebbdbee43d07/JBaker-Area51/my-hardware-configs.nix#L97
  systemd.services.ddns-updater.serviceConfig.LoadCredential = "config:${config.age.secrets.doceys-computer-ddns-config.path}";

  ###############################
  ### Radicle Seed Node (Git) ###
  ###############################

  services.radicle = {
    enable = true;
    publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKVQAWYc1m9vIBHknidQGhORM5hUTu/obR8+iMixsYJk";
    privateKeyFile = config.age.secrets.radicle-servarr-private-key.path;
    node = {
      openFirewall = true;
      listenAddress = "[::]";
      listenPort = 8776;
    };
    settings = {
      node = {
        alias = url-git;
        seedingPolicy.default = "block";
        externalAddresses = ["${url-git}:${builtins.toString config.services.radicle.node.listenPort}"];
      };
      web = {
        pinned = {
          repositories = [
            "rad:z3VieV5aCudK3sWwvPjzxAZxBCWoT" # website
          ];
        };
      };
    };
    httpd = {
      enable = true;
      listenPort = 8777;
    };
  };

  ###############
  ### Website ###
  ###############

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      80 # HTTP for my Website
      443 # HTTPS for my Website
      config.services.radicle.httpd.listenPort # Radicle HTTP Daemon
    ];
  };

  services.caddy = {
    enable = true;
    virtualHosts = {
      # Website
      ${url}.extraConfig = ''
        respond "Hello, world!"
      '';
      ${url-local}.extraConfig = ''
        respond "Hello, world!"
      '';

      # Radicle & Radicle HTTPD
      ${url-git}.extraConfig = ''
        # Radicle
        reverse_proxy ${url-git}:${builtins.toString config.services.radicle.httpd.listenPort}
        # Radicle-HTTP Daemon
        reverse_proxy ${url-local}:${builtins.toString config.services.radicle.node.listenPort}
      '';
    };
  };

  ########################
  ### Server Dashboard ###
  ########################

  virtualisation = {
    docker.enable = true;
    oci-containers = {
      backend = "docker";
      containers = {
        homarr = {
          image = "ghcr.io/homarr-labs/homarr:v1.34.0";
          volumes = [
            # "/var/run/docker.sock:/var/run/docker.sock" # Optional for docker integration. Whatever that means
            "/media/homarr/appdata:/appdata"
          ];
          ports = [
            "7575:7575"
          ];
          environmentFiles = [config.age.secrets.homarr.path];
        };

        dashdot = {
          image = "mauricenino/dashdot:6.2.0";
          privileged = true;
          volumes = [
            "/:/mnt/host:ro"
          ];
          ports = [
            "5421:3001"
          ];
          environment = {
            DASHDOT_ALWAYS_SHOW_PERCENTAGES = "true";
          };
        };
      };
    };
  };

  ##################
  ### Home Media ###
  ##################

  # Media group for all media services
  users.groups.media = {};

  services.prowlarr = {
    enable = true;
    openFirewall = true;

    settings = {
      # WARN: THIS OPTION KILLS PROWLARR COMPLETELY
      # auth.enabled = true;
      log = {
        analyticsEnabled = true;
      };
      #  server = {
      #  urlbase = "";
      #  bindaddress = "0.0.0.0";
      #  port = 1;
      #  # enablessl = true;
      #  # sslport = 6969;
      #  # sslcertpath = "";
      #  # sslcertpassword = "";
      #  };
    };
  };
  systemd.services.prowlarr = {
    serviceConfig = {
      PrivateNetwork = false;
      # ProtextSystem = "no";
      # ProtextHome = false;
    };
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
        Scheduler.end_time = ''@Variant(\0\0\0\xf\0\x36\xee\x80)'';
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
          AlternativeGlobalDLSpeedLimit = 3666; # ~30 Mbit/s
          AlternativeGlobalULSpeedLimit = 1300; # ~10 Mbit/s
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

  services.bazarr = {
    enable = true;
    openFirewall = true;
    group = "media";
    dataDir = "/media/bazarr";
  };

  systemd.tmpfiles.rules = [
    "d /media/sonarr/data 2775 sonarr media - -"
    "d /media/radarr/data 2775 radarr media - -"
  ];

  services.jellyfin = {
    enable = true;
    openFirewall = true;
    group = "media";
    dataDir = "/media/jellyfin";
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
