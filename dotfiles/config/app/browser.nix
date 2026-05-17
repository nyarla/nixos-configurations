{ pkgs, ... }:
{
  programs = {
    firefox = {
      enable = true;
      package = pkgs.firefox-bin;
      configPath = ".mozilla/firefox";
    };

    chromium = {
      enable = true;
      package = pkgs.google-chrome;
    };
  };

  home.packages = with pkgs; [
    aria-misskey
    telegram-desktop
    thunderbird-bin

    proton-authenticator
    proton-pass
  ];
}
