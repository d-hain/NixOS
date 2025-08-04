{
  pkgs,
  ...
}: {
  i18n.inputMethod = {
    enable = true;
    type = "uim";
    # ibus.engines = with pkgs.ibus-engines; [mozc];
  };
}
