{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    ethminer
    goreman
    nsfminer
    xmrig
    xmrig-cuda
  ];
}
