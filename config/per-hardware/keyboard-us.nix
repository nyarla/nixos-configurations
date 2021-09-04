{ config, pkgs, ... }: {
  console.useXkbConfig = true;
  services.xserver.layout = "us";
  services.xserver.xkbModel = "pc104";
  services.xserver.xkbOptions = "ctrl:nocaps";

  services.udev.extraRules = ''
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="04d8", ATTRS{idProduct}=="ea3b", ACTION=="add", GROUP="users", MODE="660"
  '';
}
