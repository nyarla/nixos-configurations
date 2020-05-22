{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    linuxkit
    docker_compose
    docker
  ];

  virtualisation.docker = {
    enable = true;
    storageDriver = "overlay2";
  };
}
