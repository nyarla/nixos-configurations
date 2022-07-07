{ pkgs, ... }: {
  xdg.configFile."skk/SKK-JISYO.XL".source =
    "${pkgs.skk-dicts-xl}/share/skk/SkK-JISYO.XL";
}
