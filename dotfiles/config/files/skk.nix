{ pkgs, ... }:
{
  xdg.configFile."skk/SKK-JISYO.XL".source = "${pkgs.skk-dicts-xl}/share/skk/SKK-JISYO.XL";
}
