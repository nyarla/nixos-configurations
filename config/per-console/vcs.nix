{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    gitFull
    mercurial
    subversion
    cvs
  ];
}
