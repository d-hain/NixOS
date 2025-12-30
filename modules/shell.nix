{
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    ohMyZsh = {
      enable = true;
    };

    promptInit = ''source "/home/dhain/.strug.zsh-theme"'';
    # Who even needs direnv
    interactiveShellInit = ''
      auto_nix() {
        # if a shell is active, do nothing
        [[ -n "$IN_NIX_SHELL" ]] && return

        # command depending on which file exists
        if   [[ -f flake.nix ]]; then
          nix develop . --command zsh
        elif [[ -f shell.nix || -f default.nix ]]; then
          nix-shell . --command zsh
        fi
      }

      auto_venv() {
        # if venv if already active, do nothing
        if [[ -n "$VIRTUAL_ENV" && ! -f "$VIRTUAL_ENV/bin/activate" ]]; then
          deactivate
        fi
        [[ -n "$VIRTUAL_ENV" ]] && return

        if [[ -f "./.venv/bin/activate" ]]; then
          source "./.venv/bin/activate"
        fi
      }

      autoload -Uz add-zsh-hook
      add-zsh-hook chpwd auto_nix
      add-zsh-hook chpwd auto_venv
    '';

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
      ehc = "cd ~/dotfiles/.config/hypr/ && nvim ./hyprland.conf";

      fastfetch = "fastfetch -c ~/.config/fastfetch/clean.jsonc";
    };
  };
}
