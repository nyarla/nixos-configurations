{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    linuxkit moby docker_compose docker
  ]; 

  virtualisation.docker = {
    enable = true;
    storageDriver = "overlay2";
  };
}
