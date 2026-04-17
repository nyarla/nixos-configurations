{ pkgs, ... }:
{
  # bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.consoleMode = "max";
  boot.loader.efi.canTouchEfiVariables = true;

  # for dualboot windows
  boot.loader.systemd-boot.windows = {
    "11".efiDeviceHandle = "HD2b";
  };

  # encrypted boot devices
  boot.initrd.luks.devices = {
    nixos = {
      device = "/dev/disk/by-uuid/2b254558-0847-48f0-93c6-31a26d588d01";
      preLVM = true;
      allowDiscards = true;
      bypassWorkqueues = true;
    };
  };

  swapDevices = [
    {
      device = "/dev/disk/by-partuuid/c5fdfe0f-7cbb-4354-9bb1-6c3132c4fa6d";
      randomEncryption = {
        enable = true;
        allowDiscards = true;
      };
    }
  ];

  # kernel configuration
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
    "usb_storage"
    "usbhid"
    "sd_mod"
    "sr_mod"
  ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];

  boot.kernelModules = [
    "k10temp"
    "nct6775"
  ];

  boot.kernelParams = [ "amd_pstate=active" ];
  boot.blacklistedKernelModules = [ "acpi-cpufreq" ];

  # memory ans smap
  boot.tmp.useTmpfs = true;
  boot.tmp.cleanOnBoot = true;

  zramSwap.enable = true;
  zramSwap.memoryPercent = 50;
}
