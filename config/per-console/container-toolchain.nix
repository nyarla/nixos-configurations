{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    linuxkit
    docker_compose
    docker
    act
  ];
}
