{ config, pkgs, ... }: {
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
  };

  security.sudo.enable = true;

  environment.systemPackages = with pkgs; [
    zsh
    starship
    fzy
    wcwidth-cjk

    file
    gnused
    gawk
    gnumake

    trash-cli
    inotify-tools

    bc
    tree

    perlPackages.Shell
  ];

  environment.pathsToLink = [ "/share/zsh" ];
}
