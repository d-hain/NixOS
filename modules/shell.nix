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
      cdh = "cd ~/NAS-David/FH/";
      cdw = "cd ~/NAS-David/Work/";
      cdd = "cd ~/Downloads/";

      enc = "cd ~/dotfiles/.config/nvim && nvim .";
      enx = "cd ~/dotfiles/nixos/ && nvim .";
      ehc = "cd ~/dotfiles/.config/hypr/ && nvim ./hyprland.conf";

      fastfetch = "fastfetch -c ~/.config/fastfetch/clean.jsonc";
    };
  };
  programs.direnv.enable = true;
}
