{ pkgs, ... }:
{
  programs = {
    firefox = {
      enable = true;
      package = pkgs.firefox-bin;
    };

    chromium = {
      enable = true;
      package = pkgs.google-chrome;
    };
  };

  home.packages = with pkgs; [
    bitwarden-desktop
    telegram-desktop
    thunderbird-bin
  ];
}
