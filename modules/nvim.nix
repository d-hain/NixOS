{
  lib,
  config,
  pkgs,
  wlib,
  ...
}: let
  jai-vim = pkgs.vimUtils.buildVimPlugin {
    pname = "jai-vim";
    version = "git";
    src = pkgs.fetchFromGitHub {
      owner = "rluba";
      repo = "jai.vim";
      rev = "master";
      hash = "sha256-VFNIcJmz44y/1TzJ8IpB5US5VYZwWL7FhjZC4vKOuoQ=";
    };
  };
  # tree-sitter-jai = pkgs.tree-sitter.buildGrammar {
  #   language = "jai";
  #   version = "latest";
  #   src = pkgs.fetchFromGitHub {
  #     owner = "constantitus";
  #     repo = "tree-sitter-jai";
  #     rev = "master";
  #     sha256 = "sha256-JvlylDHTXdaqN9yH/0eyTFbEOF3BtC/2joHSb7alotE=";
  #   };
  # };
in {
  imports = [
    wlib.wrapperModules.neovim
  ];

  settings.config_directory = ./nvim;
  specs = {
    general = with pkgs.vimPlugins; [
      onedark-nvim
      lualine-nvim
      gitsigns-nvim

      # (
      #   pkgs.vimPlugins.nvim-treesitter.withPlugins (p: let
      #     allGrammars = builtins.attrValues p;
      #   in
      #     allGrammars ++ [tree-sitter-jai])
      # )
      nvim-treesitter.withAllGrammars
      nvim-treesitter-context
      nvim-ts-context-commentstring
      blink-cmp
      nvim-lspconfig
      lsp_signature-nvim
      trouble-nvim
      jai-vim

      vim-illuminate
      nvim-surround
      undotree
      harpoon2
      vim-fugitive
      telescope-nvim
      todo-comments-nvim
    ];
  };

  extraPackages = with pkgs; [
    lua-language-server
    clang-tools
    # WARN: currently broken in nixos-unstable
    # ols
    glsl_analyzer
    superhtml
    tinymist
    haskell-language-server
  ];
}
