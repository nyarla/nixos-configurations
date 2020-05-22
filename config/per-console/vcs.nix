{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    gitFull
    mercurial
    bazaar
    subversion
    cvs
  ];
}
