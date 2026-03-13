{
  lib,
  config,
  pkgs,
  wlib,
  ...
}: {
  imports = [
    wlib.wrapperModules.neovim
  ];

  settings.config_directory = ./.;
  specs.general = with pkgs.vimPlugins; [
    onedarkpro-nvim
    nvim-lspconfig
    lualine-nvim
    gitsigns-nvim
    nvim-treesitter.withAllGrammars
    lazydev-nvim
  ];

  extraPackages = with pkgs; [
    lua-language-server
  ];
}
