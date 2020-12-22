{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    gitFull
    git-lfs
    mercurial
    subversion
    cvs
  ];
}
