{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    gnupg pass gitAndTools.pass-git-helper
  ]; 
}
