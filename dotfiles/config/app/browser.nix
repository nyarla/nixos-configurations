{ pkgs, ... }: {
  home.packages = with pkgs; [
    bitwarden
    firefox-bin
    google-chrome
    keepassxc
    thunderbird-bin
  ];
}
