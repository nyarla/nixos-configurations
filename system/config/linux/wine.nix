_: {
  services.udev.extraRules = ''
    KERNEL=="winesync", MODE="0644"
  '';

  boot.kernelModules = [ "winesync" ];
}
