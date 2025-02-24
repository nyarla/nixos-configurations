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
    aria-misskey
    bitwarden
    thunderbird-bin
  ];
}
