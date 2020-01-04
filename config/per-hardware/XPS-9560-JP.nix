{ config, pkgs, ... }:
{
  boot.kernelPackages = pkgs.linuxPackages;
  boot.kernelParams  = [
    "acpi_rev_override=5"
    "pcie_port_pm=off"
    "snd_hda_intel.power_save=0"
    "snd_hda_intel.power_save_controller=0"
    "usb_storage.quirks=152d:0578:u"
  ];

  boot.cleanTmpDir = true;
  boot.tmpOnTmpfs  = false;

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness"
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"
  '';
}
