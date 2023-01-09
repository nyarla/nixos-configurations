{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ podman-compose ];
  virtualisation.podman = {
    enable = true;
    defaultNetwork.settings.dns_enabled = true;
  };
}
