{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    ethminer
    goreman
    msr-tools
    nsfminer
    patchelf
    xmrig
    xmrig-cuda
  ];
}
