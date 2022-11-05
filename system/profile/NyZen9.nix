{ pkgs, lib, ... }: {
  imports = [
    ../config/audio/daw.nix
    ../config/audio/mpd.nix
    ../config/audio/pulseaudio.nix
    ../config/cpu/amd.nix
    ../config/datetime/jp.nix
    ../config/gadgets/android.nix
    ../config/graphic/fonts.nix
    ../config/graphic/labwc.nix
    ../config/graphic/lodpi.nix
    ../config/i18n/en.nix
    ../config/i18n/fcitx5.nix
    ../config/i18n/locales.nix
    ../config/keyboard/us.nix
    ../config/keyboard/zinc.nix
    ../config/linux/console.nix
    ../config/linux/dbus.nix
    ../config/linux/docker.nix
    ../config/linux/filesystem.nix
    ../config/linux/hardware.nix
    ../config/linux/lodpi.nix
    ../config/linux/optical.nix
    ../config/linux/process.nix
    ../config/linux/wine.nix
    ../config/networking/agent.nix
    ../config/networking/avahi.nix
    ../config/networking/network-manager.nix
    ../config/networking/openssh.nix
    ../config/networking/printer.nix
    ../config/networking/tailscale.nix
    ../config/networking/tcp-bbr.nix
    ../config/nixos/gsettings.nix
    ../config/nixos/nix-ld.nix
    ../config/security/clamav.nix
    ../config/security/firewall-home.nix
    ../config/security/gnupg.nix
    ../config/tools/editors.nix
    ../config/tools/git.nix
    ../config/user/nyarla.nix
    ../config/video/droidcam.nix
    ../config/video/nvidia.nix
    ../config/wireless/AX200.nix
    ../config/wireless/bluetooth.nix
    ../config/wireless/jp.nix
  ];

  # Machine specific configurations
  # ===============================

  # Boot
  # ----

  # bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.consoleMode = "max";
  boot.loader.efi.canTouchEfiVariables = true;

  # initrd
  boot.initrd.luks.devices = {
    nixos = {
      device = "/dev/disk/by-uuid/81494384-9f87-4e1c-917a-b5741306fd99";
      preLVM = true;
      allowDiscards = false;
      bypassWorkqueues = true;
    };
  };

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];

  # tmpfs
  boot.cleanTmpDir = true;
  boot.tmpOnTmpfs = true;

  # kernel
  boot.kernelPackages = pkgs.linuxKernel.packageAliases.linux_latest;
  boot.kernelModules = [ "kvm-amd" "k10temp" "nct6775" ];
  boot.kernelParams = [
    "iwlwifi.power_save=0"
    "iwlmvm.power_scheme=1"

    "noibrs"
    "pti=off"
    "kpti=off"
  ];

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

  # Hardware
  # --------

  # cpu
  powerManagement.cpuFreqGovernor = "performance";

  # firmware
  hardware.enableRedistributableFirmware = true;

  # Services
  # --------

  # backup
  systemd.user.services.backup = {
    enable = true;
    description = "Automatic backup by restic and rclone";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = toString (pkgs.writeShellScript "backup.sh" ''
        set -euo pipefail

        export PATH=${lib.makeBinPath (with pkgs; [ restic-run ])}:$PATH
        export HOME=/home/nyarla
        export DATA=/run/media/nyarla/data

        cd $DATA
        for dir in Downloads Music Photo local ; do
          restic-backup $dir
        done

        cd $HOME
        restic-backup Documents

        exit 0
      '');
    };
  };
  systemd.user.timers.backup = {
    enable = true;
    description = "Timer for automatic backup by restic and rclone";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 01:00:00";
      RandomizedDelaySec = "5m";
      Persistent = true;
    };
  };

  # ClamAV
  services.clamav.daemon.settings = {
    LogFile = "/home/nyarla/ClamAV/scan.log";
    ExcludePath = [
      "^/bin"
      "^/boot"
      "^/dev"
      "^/home/nyarla/ClamAV"
      "^/home/postgres"
      "^/lost+found"
      "^/nix"
      "^/proc"
      "^/sys"
    ];
    MaxThreads = 30;
  };

  systemd.services.clamav-scan = {
    enable = true;
    description = "Full Virus Scan by ClamAV";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = toString (pkgs.writeShellScript "clamav-scan.sh" ''
        set -euo pipefail

        export PATH=${lib.makeBinPath (with pkgs; [ clamav ])}:$PATH

        rm /home/nyarla/ClamAV/scan.log
        clamdscan -i -m --fdpass / || true
        chown nyarla:users /home/nyarla/ClamAV/scan.log

        exit 0
      '');
    };
  };

  systemd.timers.clamav-scan = {
    enable = true;
    description = "Full Virus Scan by ClamAV";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 03:00:00";
      RandomizedDelaySec = "5m";
      Persistent = true;
    };
  };
}
