{ pkgs, ... }:
{
  i18n = rec {
    defaultLocale = "en_US.UTF-8";
    extraLocales = [
      "en_US.UTF-8/UTF-8-EAW-CONSOLE"
      "ja_JP.UTF-8/UTF-8-EAW-CONSOLE"
    ];
    glibcLocales = pkgs.glibc-locales-eaw.override {
      allLocales = false;
      locales = extraLocales;
    };
  };
}
