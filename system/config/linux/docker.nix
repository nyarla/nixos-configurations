{ config, pkgs, ... }: {
  virtualisation.docker = {
    enable = true;
    storageDriver = "overlay2";
    enableNvidia = true;
  };
  environment.systemPackages = with pkgs; [ docker ];
}
