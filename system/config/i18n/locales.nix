{ pkgs, lib, config, ... }:
let
  glibc-eaw = pkgs.glibc.overrideAttrs (old: rec {
    postUnpack = ''
      cp ${pkgs.locale-eaw}/UTF-8 ${pkgs.glibc.pname}-${pkgs.glibc.version}/localedata/charmaps/UTF-8
    '';
  });
in {
  i18n.glibcLocales = (pkgs.buildPackages.glibcLocales.override {
    glibc = glibc-eaw;
    allLocales = lib.any (x: x == "all") config.i18n.supportedLocales;
    locales = config.i18n.supportedLocales;
  });

  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" "ja_JP.UTF-8/UTF-8" ];
}
