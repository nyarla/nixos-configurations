_: {
  imports = [
    ../config/audio/pipewire.nix
    ../config/cpu/amd.nix
    ../config/datetime/jp.nix
    ../config/i18n/en.nix
    ../config/keyboard/us.nix
    ../config/keyboard/zinc.nix
    ../config/linux/console.nix
    ../config/linux/lodpi.nix
    ../config/radio/jp.nix
    ../config/user/nyarla.nix
    ../config/wireless/bluetooth.nix
  ];

  # More customizations
  # -------------------

  # CPU
  # ---
  powerManagement.cpuFreqGovernor = "performance";

}
