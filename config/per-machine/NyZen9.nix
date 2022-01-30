{ config, modulesPath, pkgs, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")

    ../per-hardware/audio.nix
    ../per-hardware/bluetooth.nix
    ../per-hardware/console.nix
    ../per-hardware/keyboard-us.nix
    ../per-hardware/nvidia.nix
    ../per-hardware/optical.nix
    ../per-hardware/tcp-bbr.nix

    ../per-toolchain/hardware.nix
  ];

  # kernel
  boot.initrd.availableKernelModules =
    [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_lqx;
  boot.kernelModules = [ "kvm-amd" "k10temp" "nct6775" ];
  boot.kernelParams = [ "iwlwifi.power_save=0" "iwlmvm.power_scheme=1" ];

  # bootloader
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot = {
    enable = true;
    consoleMode = "max";
  };
  boot.initrd.luks.devices = {
    nixos = {
      device = "/dev/disk/by-uuid/81494384-9f87-4e1c-917a-b5741306fd99";
      preLVM = true;
      allowDiscards = false;
    };
  };

  # tmpfs
  boot.cleanTmpDir = true;
  boot.tmpOnTmpfs = true;

  # cpu
  hardware.cpu.amd.updateMicrocode = true;
  powerManagement.cpuFreqGovernor = "performance";

  # filesystem
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/cd13a39c-a851-4bf1-85c6-488e4d0cbb85";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/B0F5-8B2B";
    fsType = "vfat";
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/165fa545-d372-4799-b9f5-ffb71f34def6";
    fsType = "ext4";
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/3a0ce4be-abf2-4c3e-9aa1-0845c8d4a114";
    fsType = "ext4";
  };

  swapDevices = [ ];
}
