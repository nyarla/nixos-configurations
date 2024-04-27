{ pkgs, ... }:
{
  boot.kernelModules = [ "uinput" ];

  hardware.keyboard.qmk.enable = true;

  services.udev.extraRules = ''
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="04d8", ATTRS{idProduct}=="ea3b", ACTION=="add", GROUP="users", MODE="660"
    KERNEL=="uinput", GROUP="input", MODE="660"
  '';

  services.udev.packages = with pkgs; [ vial ];

  environment.systemPackages = with pkgs; [
    qmk
    vial
  ];
}
