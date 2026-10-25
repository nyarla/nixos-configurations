_: {
  mod.wireless.bluetooth.enable = true;

  # for AX200
  boot.kernelParams = [
    "iwlwifi.power_save=0"
    "iwlmvm.power_scheme=1"
  ];
}
