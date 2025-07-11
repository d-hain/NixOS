{
  lib,
  config,
  pkgs,
  ghostty,
  fuzzel-pass,
  ...
}: {
  options.user = {
    enable = lib.mkEnableOption "User Account";

    username = lib.mkOption {
      default = "luffy";
      description = "Username";
    };

    packages = lib.mkOption {
      default = [];
      description = "Additional system specific packages";
    };
  };

  config = lib.mkIf config.user.enable {
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.${config.user.username} = {
      isNormalUser = true;
      extraGroups = [
        "wheel" # Enable ‘sudo’ for the user
        "libvirtd" # Virtualisation using libvirt
        "docker" # I hate docker with a passion
      ];

      shell = pkgs.zsh;

      # :packages
      packages = with pkgs; [
        #################
        ### Utilities ###
        #################

        gcc14
        clang_18
        man-pages
        man-pages-posix
        gdb
        eza
        sl
        ripgrep
        fastfetch
        btop
        stow
        gnumake
        odin # (nearly) Up to date Odin compiler
        rustup
        python3

        # Terminal Programs
        (ghostty.packages.${pkgs.system}.default)
        kdePackages.konsole # Fallback terminal
        typst
        typst-live
        ffmpeg
        imagemagick
        sendme # Ultimate magic and just the best thing ever
        comma

        # Neovim and LSPs
        neovim
        lua-language-server
        clang-tools
        ols
        glsl_analyzer
        superhtml
        tinymist

        #######################
        ### "Desktop" Stuff ###
        #######################

        fuzzel
        bemoji
        waybar
        hyprshot
        hyprsunset
        pavucontrol
        # Bluetooth GUI (doesn't work but makes it work) see:
        # https://github.com/bluez/bluez/issues/673#issuecomment-1849132576
        # https://wiki.nixos.org/wiki/Bluetooth
        blueman # basically the same as `services.blueman.enable = true;`
        # Dolphin with Wayland and SVG Icon support
        kdePackages.qtwayland
        kdePackages.qtsvg
        kdePackages.dolphin

        # Clipboard
        wl-clipboard
        cliphist

        # Cursor theme
        hyprcursor
        banana-cursor
        glib

        #######################
        ### Normal Programs ###
        #######################

        firefox
        brave
        ungoogled-chromium
        vesktop
        gimp3
        anki
        synology-drive-client
        mpv
        teams-for-linux
        onlyoffice-desktopeditors
        thunderbird
        signal-desktop

        # Password Store
        # only for importing from SafeInCloud
        # (pkgs.pass.withExtensions (p: [p.pass-import]))
        pass
        (fuzzel-pass.packages.${pkgs.system}.default)

        # Minecraft
        prismlauncher
      ] ++ config.user.packages;
    };
  };
}
