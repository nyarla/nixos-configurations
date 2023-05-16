{ pkgs, ... }: {
  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
    enableNvidia = true;
  };
  environment.systemPackages = with pkgs; [ docker ];
}
