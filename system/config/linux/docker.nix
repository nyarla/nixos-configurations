{ pkgs, ... }: {
  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
  };
  environment.systemPackages = with pkgs; [ docker ];
}
