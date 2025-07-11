{
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    ohMyZsh = {
      enable = true;
    };

    promptInit = ''source "/home/dhain/.strug.zsh-theme"'';
    shellInit = "clear";

    shellAliases = {
      cls = "clear";
      csl = "sl";

      l = "eza -lah --icons";
      ls = "eza";
      ll = "eza -la --icons";
      la = "eza -a";

      cda = "cd ~/NAS-David/anime-manga-notes";
      cdp = "cd ~/NAS-David/Programming/";
      cdd = "cd ~/Downloads/";

      enc = "cd ~/dotfiles/.config/nvim && nvim .";
      enx = "cd ~/dotfiles/nixos/ && nvim .";
      enxc = "cd ~/NixOS/ && nvim ./hosts/default/configuration.nix";
      ehc = "cd ~/dotfiles/.config/hypr/ && nvim ./hyprland.conf";

      fastfetch = "fastfetch -c ~/.config/fastfetch/clean.jsonc";
    };
  };
  programs.direnv.enable = true;
}
