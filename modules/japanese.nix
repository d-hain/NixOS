{
  pkgs,
  lib,
  ...
}: {
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";

    fcitx5 = {
      waylandFrontend = true;
      ignoreUserConfig = lib.mkDefault true;

      addons = with pkgs; [fcitx5-mozc fcitx5-gtk];
      settings = {
        inputMethod = {
          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "de";
            DefaultIM = "keyboard-de";
          };
          "Groups/0/Items/0" = {
            Name = "keyboard-de";
            Layout = "de";
            Variant = "nodeadkeys";
          };
          "Groups/0/Items/1" = {
            Name = "mozc";
          };
        };
      };
    };
  };

  fonts.packages = with pkgs; [noto-fonts-cjk-sans noto-fonts-cjk-serif];
}
