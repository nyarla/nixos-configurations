{ config, pkgs, ... }: {
  boot.kernelPackages = pkgs.linuxPackages_4_19;
  boot.kernelParams = [
    "acpi_rev_override=1"
    "i915.enable_fbc=1"
    "i915.enable_psr=1"
    "i915.disable_power_well=0"
    "pci=nommconf"
    "pcie_aspm=force"
    "nmi_watchdog=0"
    "dell-smm-hwmon.ignore_dmi=1"
    "usb_storage.quirks=152d:0578:u,2537:1066:u"
  ];

  boot.cleanTmpDir = true;
  boot.tmpOnTmpfs = false;

  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="138a", ATTRS{idProduct}=="0091", ATTR{authorized}="0"
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness"
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"
  '';
}
