{ pkgs, ... }: {
  home.packages = with pkgs; [
    bitwarden
    brave
    firefox
    google-chrome
    keepassxc
    thunderbird-bin
    whalebird
  ];
}
