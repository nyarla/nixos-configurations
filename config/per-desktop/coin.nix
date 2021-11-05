{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    electrum
    electrum-ltc
    goreman
    msr-tools
    nsfminer
    xmrig
  ];

  services.dbus.packages = with pkgs; [ electrum electrum-ltc ];
}
