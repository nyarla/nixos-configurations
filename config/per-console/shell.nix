{ config, pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
  };

  security.sudo.enable = true;

  environment.systemPackages = with pkgs; [
    zsh fzy wcwidth-cjk
    tmux tmux-up
    file gnused gawk gnumake
    trash-cli
    inotify-tools
  ];
}
