{ pkgs, ... }: {
  home.packages = with pkgs; [
    bitwarden
    brave
    firefox-bin
    google-chrome
    keepassxc
    thunderbird-bin
    whalebird
  ];
}
