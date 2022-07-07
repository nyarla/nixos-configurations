_: {
  boot.kernelModules = [ "uinput" ];

  services.udev.extraRules = ''
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="04d8", ATTRS{idProduct}=="ea3b", ACTION=="add", GROUP="users", MODE="660"
    KERNEL=="uinput", GROUP="input", MODE="660"
  '';
}
