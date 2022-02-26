{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    ethminer
    goreman
    msr-tools
    nsfminer
    xmrig
    xmrig-cuda
  ];
}
