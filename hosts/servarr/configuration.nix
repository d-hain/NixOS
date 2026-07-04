# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  lib,
  config,
  pkgs,
  nix-wrapper-modules,
  ...
}: let
  url-local = "192.168.1.69";
  url = "doceys.computer";
  # TODO: Make a Git-Frontend for this
  url-git = "git." + url;
  url-dawarich = "dawarich." + url;
  url-immich = "immich." + url;
  domains = [url url-git url-dawarich url-immich];

  local-services = {
    "prowlarr.sameg" = config.services.prowlarr.settings.server.port;
    "qbittorrent.sameg" = config.services.qbittorrent.webuiPort;
    "sonarr.sameg" = config.services.sonarr.settings.server.port;
    "radarr.sameg" = config.services.radarr.settings.server.port;
    "bazarr.sameg" = config.services.bazarr.listenPort;
    "jellyfin.sameg" = 8096;
  };
in {
  imports = [
    ./hardware-configuration.nix
    ./secrets.nix
    ../../modules/nix.nix
    ../../modules/environment.nix
    ../../modules/user.nix
    ../../modules/syncthing.nix
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
  };

  user.username = "doce";
  users.users.${config.user.username} = {
    isNormalUser = true;
    extraGroups = ["wheel"]; # Enable ‘sudo’ for the user.

    # extra :packages
    packages = with pkgs; [
      (nix-wrapper-modules.lib.evalPackage [
        ../../modules/nvim.nix
        {inherit pkgs;}
      ])
      # Git-system wrapper a la https://github.com/NixOS/nixpkgs/blob/a4bf06618f0b5ee50f14ed8f0da77d34ecc19160/nixos/modules/services/misc/radicle.nix#L19
      (pkgs.writeShellScriptBin "git-sys" ''
        # Use sudo to run the git command as the "git" user.
        exec ${config.security.wrapperDir}/sudo -u git -- ${lib.getExe pkgs.git} "$@"
      '')
    ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILExjAbpsovl1IAt/cgGo1NiQfe0rYOdkjPZ+yqPfLc5 d-hain"
    ];
  };

  # Shell
  programs.bash = {
    shellAliases = {
      cls = "clear";
    };
  };

  # Git Server setup
  users.groups.git = {};
  users.users.git = {
    isSystemUser = true;
    description = "Git System User";
    group = "git";
    home = "/home/git";
    createHome = true;

    shell = lib.getExe' pkgs.git "git-shell";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILExjAbpsovl1IAt/cgGo1NiQfe0rYOdkjPZ+yqPfLc5 d-hain"
    ];
  };

  services.fcgiwrap.instances.git-http = {
    process = {
      user = "git";
      group = "git";
    };
    socket = {
      user = "caddy";
      group = "caddy";
      address = "/run/fgciwrap-git.sock";
    };
  };

  syncthing = {
    enable = true;
    peers = {
      pc = {id = "WRYBK4C-BMRSC7C-5CYSGDU-PE3H2DK-EVFFX7R-UF3UOFB-RMKJNXM-OLRGBQR";};
      laptop = {id = "5TGBSL7-WJBWPYJ-HV2COFK-SR5VC7F-VA47MAA-I3LO4XF-W3E5X5X-KECH4AP";};
    };
    keyFile = ../../secrets/servarr-syncthing-key.age;
    certFile = ../../secrets/servarr-syncthing-cert.age;
  };

  # Systemd Timer to schedule the backup below weekly
  systemd.timers.synology-backup = {
    wantedBy = ["timers.target"];
    timerConfig = {
      # The NAS is turned off from 01:00 - 07:00
      OnCalendar = "Mon *-*-* 09:00:00";
      Persistent = true;
    };
  };
  systemd.services.synology-backup = {
    description = "Weekly rsync backup of my Syncthing files to my Synology NAS";
    after = ["network-online.target"];
    wants = ["network-online.target"];

    serviceConfig = {
      Type = "oneshot";
      User = config.user.username;
      TimeoutStartSec = "3min";
    };

    script = ''
      ${lib.getExe pkgs.rsync} -avz --delete \
        ${config.services.syncthing.settings.folders.Sync.path} \
        rsync-backup@hainasat.synology.me::David-Backup/Sync-Backup \
        --password-file=${config.age.secrets.synology-rsync-backup-pwd.path}
    '';
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
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };

    # Git Server config
    extraConfig = ''
      Match user git
        AllowTcpForwarding no
        AllowAgentForwarding no
        PasswordAuthentication no
        KbdInteractiveAuthentication no
        PermitTTY no
        X11Forwarding no
    '';
  };

  # DDNS
  services.ddclient = {
    enable = true;
    verbose = true;
    protocol = "porkbun";
    usev4 = "webv4,webv4=ifconfig.me/ip";
    usev6 = "";
    extraConfig = "root-domain=${url}";
    domains = domains;
    secretsFile = config.age.secrets.ddclient-secrets.path;
  };

  ###############
  ### Website ###
  ###############

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      53 # Local DNS Server (Blocky)
      80 # HTTP for my Website
      443 # HTTPS for my Website
    ];
    allowedUDPPorts = [
      53 # Local DNS Server (Blocky)
    ];
  };

  services.caddy = {
    enable = true;
    enableReload = false;
    globalConfig = ''
      # Disable admin page on port 2019
      admin off

      # Set fixed Root Certificate and Key
      pki {
        ca local {
          root {
            cert ${./root.crt}
            key ${config.age.secrets.caddy_root_key.path}
          }
        }
      }
    '';
    virtualHosts = let
      public-domains = {
        # Website
        # TODO: make actually good
        ${url}.extraConfig = ''
          root * ${./assets}
          file_server
        '';

        ${url-git}.extraConfig = ''
          reverse_proxy unix/${config.services.fcgiwrap.instances.git-http.socket.address} {
            transport fastcgi {
              env SCRIPT_FILENAME ${pkgs.git}/libexec/git-core/git-http-backend
              env GIT_PROJECT_ROOT ${config.users.users.git.home}
            }
          }
        '';

        ${url-immich}.extraConfig = ''
          reverse_proxy http://localhost:${builtins.toString config.services.immich.port}

          encode zstd gzip
          request_body {
            max_size 5000MB
          }
        '';

        ${url-dawarich}.extraConfig = ''
          root * ${config.services.dawarich.package}/public
          file_server

          # If a file is not found locally proxy to dawarich
          @file-not-found not file
          reverse_proxy @file-not-found http://localhost:${builtins.toString config.services.dawarich.webPort}

          # brotli is recommended, but i don't want to install the caddy plugin for it
          encode zstd gzip
        '';
      };

      local-configs =
        builtins.mapAttrs (name: port: {
          extraConfig = ''
            tls internal
            reverse_proxy localhost:${builtins.toString port}
          '';
        })
        local-services;
    in
      public-domains // local-configs;
  };

  # Local DNS
  networking.nameservers = ["127.0.0.1"];
  services.blocky = {
    enable = true;
    settings = {
      upstreams.groups.default = [
        "https://dns.quad9.net/dns-query"
        "https://one.one.one.one/dns-query"
        "https://dns.google/dns-query" # Cursed ass domain
        "9.9.9.9"
        "1.1.1.1"
        "8.8.8.8"
      ];
      customDNS = {
        mapping = let
          public-domains = lib.genAttrs domains (name: url-local);
          local-domains = builtins.mapAttrs (name: _: url-local) local-services;
        in
          public-domains // local-domains;
      };
    };
  };

  services.immich = {
    enable = true;
    openFirewall = true;
    mediaLocation = "/media/immich";

    settings = {
      server.externalDomain = "https://" + url-immich;
    };
    # environment = {
    # };
  };

  services.dawarich = {
    enable = true;
    configureNginx = false; # Nginx is my enemy and Caddy is my friend!
    localDomain = url-dawarich;
    secretKeyBaseFile = config.age.secrets.dawarich-secret-key-base.path;
  };

  ########################
  ### Server Dashboard ###
  ########################

  # TODO: Make my own (or setup Graphana or smth)

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
    };
  };
  systemd.services.prowlarr = {
    serviceConfig = {
      PrivateNetwork = false;
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
