{ pkgs, ... }: {
  imports = [
    ../config/audio/pulseaudio.nix
    ../config/cpu/amd.nix
    ../config/datetime/jp.nix
    ../config/i18n/en.nix
    ../config/i18n/locales.nix
    ../config/keyboard/us.nix
    ../config/keyboard/zinc.nix
    ../config/linux/console.nix
    ../config/linux/filesystem.nix
    ../config/linux/lodpi.nix
    ../config/linux/optical.nix
    ../config/linux/wine.nix
    ../config/networking/agent.nix
    ../config/networking/tcp-bbr.nix
    ../config/nixos/gsettings.nix
    ../config/nixos/nix-ld.nix
    ../config/tools/git.nix
    ../config/tools/nvim.nix
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
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_lqx;
  boot.kernelModules = [ "kvm-amd" "k10temp" "nct6775" ];
  boot.kernelParams = [ "iwlwifi.power_save=0" "iwlmvm.power_scheme=1" ];

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
    requiredBy = [ "default.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = toString (pkgs.writeShellScript "backup.sh" ''
        export PATH=${pkgs.restic-run}/bin:${pkgs.coreutils}/bin:$PATH
        export HOME=/home/nyarla
        export MEDIA=/run/media/nyarla

        if test -e $HOME/.cache/backup.lock ; then
          echo "backup process is running or dead lokced"
          exit 0
        fi

        touch $HOME/.cache/backup.lock

        if test -e $HOME/Documents ; then
          cd $HOME/Documents && restic-backup documents .
        fi

        if test -e $HOME/local ; then
          cd $HOME/local && restic-backup dotfiles .
        fi

        if test -e $MEDIA/data/Downloads ; then
          cd $MEDIA/data/Downloads && restic-backup stuck .
        fi

        if test -e $MEDIA/data/local ; then
          cd $MEDIA/data/local && restic-backup source .
        fi

        if test -e $MEDIA/src/local ; then
          cd $MEDIA/src/local && restic-backup daw .
        fi

        if test -e $MEDIA/src/Music ; then
          cd $MEDIA/src/Music && restic-backup musics .
        fi

        rm $HOME/.cache/backup.lock
      '');
    };
  };
  systemd.user.timers.backup = {
    enable = true;
    description = "Timer for automatic backup by restic and rclone";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 02:00:00";
      RandomizedDelaySec = "5m";
      Persistent = true;
    };
  };
}
