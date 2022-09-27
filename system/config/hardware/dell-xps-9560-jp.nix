_: {
  boot.kernelParams = [
    # HW monitor
    # "dell-smm-hwmon.ignore_dmi=1"

    # Power saving (Intel)
    "i915.enable_fbc=1"
    "i195.enable_psr=1"
    "i915.disable_power_well=0"

    # dmesg error
    # "pcie_aspm=off"
    # "pci=nommconf"

    # optimize
    "nmi_watchdog=0"
  ];

  boot.cleanTmpDir = true;
  boot.tmpOnTmpfs = false;

  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="138a", ATTRS{idProduct}=="0091", ATTR{authorized}="0"
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness"
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"
  '';

  services.hardware.bolt.enable = true;
}
