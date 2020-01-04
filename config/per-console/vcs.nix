{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    git
    mercurial
    bazaar
    subversion
    cvs 
  ];
}
