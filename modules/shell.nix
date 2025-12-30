{
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    promptInit = ''
      autoload -U colors
      colors

      setopt PROMPT_SUBST

      export CLICOLOR=1
      export LSCOLORS=dxFxCxDxBxegedabagacad
      VIRTUAL_ENV_DISABLE_PROMPT=1

      # Detect nix shell
      in_nix_shell() {
        if [[ -n "$IN_NIX_SHELL" ]]; then
          echo -n " shell";
        fi
      }

      # Detect venv
      in_venv() {
        if [[ -n "$VIRTUAL_ENV" ]]; then
          echo -n " venv";
        fi
      }

      # Detect shell level
      shell_level() {
        if [[ "$SHLVL" > 1 ]]; then
          echo -n "%F{214}$SHLVL%f";
        fi
      }

      #################
      ### Git stuff ###
      #################

      git_branch() {
        local branch
        branch=$(git symbolic-ref --short HEAD 2>/dev/null) || return
        echo -n " %F{yellow}on $branch%f";
      }

      git_dirty() {
        if git -C "$dir" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
          if [ -n "$(git -C "$dir" status --porcelain)" ]; then
            echo -n " %F{red}✘%f";
          else
            echo -n " %F{green}✔%f";
          fi
        fi
      }

      git_remote_status() {
        local upstream ahead behind rev_list

        upstream=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null) || return

        rev_list=$(git rev-list --left-right --count HEAD...@{u})
        ahead=$(echo "$rev_list" | cut -f1)
        behind=$(echo "$rev_list" | cut -f2)

        echo -n "%F{yellow}($upstream"

        ((  ahead > 0 )) && echo -n " %F{green}+$ahead%f"
        (( behind > 0 )) && echo -n " %F{red}-$behind%f"

        echo -n "%F{yellow})%f"
      }

      status_line() {
        local nix
        nix=$(in_nix_shell)
        [[ -n "$nix" ]] && echo -n " %F{blue}$nix%f";
      }

      git_line() {
        echo -n "$(git_branch)$(git_dirty) $(git_remote_status)"
      }

      PROMPT=$'%F{green}╭─%n@%m%f$(status_line) %F{yellow}in %~%f$(git_line) $(shell_level)\n%F{green}╰$ %f'
    '';
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

      enc = "nvim +'cd ~/dotfiles/.config/nvim/'";
      ehc = "nvim +'cd ~/dotfiles/.config/hypr/' ~/dotfiles/.config/hypr/hyprland.conf";

      fastfetch = "fastfetch -c ~/.config/fastfetch/clean.jsonc";
    };
  };
}
