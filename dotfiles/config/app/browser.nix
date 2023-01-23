{ pkgs, ... }: {
  programs.firefox.enable = true;
  programs.firefox.package = pkgs.firefox-bin;

  home.packages = with pkgs; [
    brave
    google-chrome
    thunderbird-bin
    tooth
    whalebird
  ];
}
