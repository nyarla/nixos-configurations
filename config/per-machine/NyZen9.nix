{ config, ... }: {
  imports = [
    ../per-hardware/audio.nix
    ../per-hardware/bluetooth.nix
    ../per-hardware/console.nix
    ../per-hardware/keyboard-us.nix
    ../per-hardware/nvidia.nix
    ../per-hardware/optical.nix
    ../per-hardware/tcp-bbr.nix

    ../per-console/hardware.nix
  ];

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot = {
    enable = true;
    consoleMode = "max";
  };

  boot.cleanTmpDir = true;
  boot.tmpOnTmpfs = true;
  boot.kernelModules = [ "k10temp" "nct6775" ];

  hardware.cpu.amd.updateMicrocode = true;
}
