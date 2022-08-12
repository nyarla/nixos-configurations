{ pkgs, ... }: {
  home.packages = with pkgs; [
    bitwarden
    firefox
    google-chrome
    keepassxc
    thunderbird-bin
  ];
}
