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
    ols
    glsl_analyzer
    superhtml
    tinymist
    haskell-language-server
  ];
}
