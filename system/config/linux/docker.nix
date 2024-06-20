{ pkgs, ... }:
{
  virtualisation.docker = {
    enable = true;
    storageDriver = "overlay2";
    daemon.settings = {
      dns = [
        "1.1.1.1"
        "1.0.0.1"
      ];
    };
  };
  environment.systemPackages = with pkgs; [ docker ];
}
