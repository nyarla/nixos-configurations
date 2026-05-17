{ pkgs, ... }:
{
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    extraPackages = with pkgs; [
      docker-client
      docker-compose
    ];
  };
}
