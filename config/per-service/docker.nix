{ config, pkgs, ... }: {
  virtualisation.docker = {
    enable = true;
    storageDriver = "overlay2";
  };
}
