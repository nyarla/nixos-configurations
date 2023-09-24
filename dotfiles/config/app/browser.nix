{ pkgs, ... }: {
  programs.firefox.enable = true;
  programs.firefox.package = pkgs.firefox-bin;

  programs.google-chrome.enable = true;
  programs.brave.enable = true;

  home.packages = with pkgs; [ thunderbird-bin bitwarden ];
}
