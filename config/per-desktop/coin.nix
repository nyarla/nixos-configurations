{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    electrum
    electrum-ltc
    goreman
    msr-tools
    nsfminer
    xmrig
  ];
}
