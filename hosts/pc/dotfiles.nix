{
  config,
  pkgs,
  lib,
  ...
}: let
  helpers = import ../../lib/generate-dotfiles.nix {inherit config pkgs lib;};
  dotfileScript = helpers.generateDotfileLinks {
    sharedDir = ../../dotfiles;
    hostDir = ./dotfiles;
  };
in {
  system.activationScripts.dotfileLinks.text = ''
    ${dotfileScript}
  '';
}
