{ pkgs, lib, ... }:
let
  # usage: environment.etc."libvirt/hooks/qemu.d/${vmane}/prepare/begin/hugepage.sh"
  kvmHugePageSetupScript = pkgs.writeShellScript "hugepage-setup.sh" ''
    set -x

    HUGEPAGE=32800
    echo $HUGEPAGE > /proc/sys/vm/nr_hugepages
    ALLOC_PAGES=$(cat /proc/sys/vm/nr_hugepages)

    TRIES=0
    while (( $ALLOC_PAGES != $HUGEPAGE && $TRIES < 1000 )); do
      echo 1 > /proc/sys/vm/compact_memory
      echo $HUGEPAGE > /proc/sys/vm/nr_hugepages
      ALLOC_PAGES=$(cat /proc/sys/vm/nr_hugepages)

      let TRIES+=1
    done

    if test $HUGEPAGE != $ALLOC_PAGES ; then
      echo "failed to enable hugepage"
      echo 0 > /proc/sys/vm/nr_hugepages
      exit 1
    fi
  '';

  # usage: environment.etc."libvirt/hooks/qemu.d/${vmane}/release/end/hugepage.sh"
  kvmHugePageShutdownScript = pkgs.writeShellScript "hugepage-shutdown.sh" ''
    echo 0 > /proc/sys/vm/nr_hugepages
  '';

  # usage: environment.etc."libvirt/hooks/qemu.d/${vmane}/prepare/begin/vfio.sh"
  kvmVFIOSetupScript = pkgs.writeShellScript "vfio-setup.sh" ''
    set -x
    export PATH=${lib.makeBinPath (with pkgs; [ kmod procps libvirt ])}:$PATH

    # shutdown display manager
    if systemctl is-active display-manager ; then
      systemctl stop display-manager
    fi

    while systemctl is-active --quiet display-manager; do
      sleep 1
    done

    # unbind vtcon
    for i in $(seq 0 16); do
      if test "$(grep -c 'frame buffer' "/sys/class/vtconsole/vtcon''${i}/name")" == 1; then
        echo 0 > /sys/class/vtconsole/vtcon''${i}/bind
        echo "''${i}" >> /tmp/vfio-bound-consoles
      fi
    done

    # unload gpu drivers
    echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind
    modprobe -r nvidia_uvm
    modprobe -r nvidia_drm
    modprobe -r nvidia_modeset
    modprobe -r nvidia
    modprobe -r drm_kms_helper
    modprobe -r drm

    # load vfio drivers
    modprobe vfio
    modprobe vfio_pci
    modprobe vfio_iommu_type1
  '';

  # usage: environment.etc."libvirt/hooks/qemu.d/${vmane}/release/end/vfio.sh"
  kvmVFIOShutdownScript = pkgs.writeShellScript "vfio-shutdown.sh" ''
    set -x
    export PATH=${lib.makeBinPath (with pkgs; [ kmod procps libvirt ])}:$PATH

    # unload vfio kernel modules
    modprobe -r vfio_pci
    modprobe -r vfio_iommu_type1
    modprobe -r vfio

    # load gpu drivers
    modprobe drm
    modprobe drm_kms_helper
    modprobe nvidia
    modprobe nvidia_modeset
    modprobe nvidia_drm
    modprobe nvidia_uvm

    # start display manager
    systemctl start display-manager

    # attach vtcon
    input="/tmp/vfio-bound-consoles"
    while read -r idx ; do
      if -x "/sys/class/vtconsole/vtcon''${idx}"; then
        if test "$(grep -c 'frame buffer' "/sys/class/vtconsole/vtcon''${idx}/name")" = 1; then
          echo 1 > /sys/class/vtconsole/vtcon''${idx}/bind
        fi
      fi
    done < "$input"
  '';

  btrfsOptions = [ "compress=zstd" "ssd" "space_cache=v2" ];
  btrfsRWOnly = [ "noexec" "nosuid" "nodev" ];
in {
  imports = [
    ../config/audio/pulseaudio.nix
    ../config/cpu/amd.nix
    ../config/datetime/jp.nix
    ../config/desktop/files.nix
    ../config/desktop/wayland.nix
    ../config/desktop/xorg.nix
    ../config/gadgets/android.nix
    ../config/graphic/fonts.nix
    ../config/graphic/labwc.nix
    ../config/graphic/lodpi.nix
    ../config/graphic/xorg.nix
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
    ../config/linux/kvm.nix
    ../config/linux/lodpi.nix
    ../config/linux/optical.nix
    ../config/linux/process.nix
    ../config/linux/waydroid.nix
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
    ../config/nixos/nixpkgs.nix
    ../config/security/1password.nix
    ../config/security/clamav.nix
    ../config/security/firewall-home.nix
    ../config/security/gnupg.nix
    ../config/security/yubikey.nix
    ../config/tools/editors.nix
    ../config/tools/git.nix
    ../config/user/nyarla.nix
    ../config/video/droidcam.nix
    ../config/video/nvidia.nix
    ../config/webapp/NyZen9.nix
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

  boot.postBootCommands = ''
    mkdir -p /usr
    ln -sf /etc/persist/usr/share /usr/share
  '';

  # initrd
  boot.initrd.luks.devices = {
    nixos = {
      device = "/dev/disk/by-uuid/c79e2e2d-5411-4af3-8951-549c70f922cb";
      preLVM = true;
      allowDiscards = true;
      bypassWorkqueues = true;
    };

    data = {
      device = "/dev/disk/by-uuid/8590c1c4-daf4-441e-a076-8c9376e4cda8";
      preLVM = true;
      allowDiscards = true;
      bypassWorkqueues = true;
    };
  };

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "ahci" "nvme" "usb_storage" "uas" "usbhid" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];

  # tmpfs
  boot.tmp.useTmpfs = true;
  boot.tmp.cleanOnBoot = true;

  zramSwap.enable = true;
  zramSwap.memoryPercent = 50;

  # kernel
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod;
  boot.kernelModules = [ "kvm-amd" "k10temp" "nct6775" "kvm" "kvm-amd" ];
  boot.kernelParams = [
    # CPU
    "noibrs"
    "pti=off"
    "kpti=off"

    # KVM
    "vfio-pci.ids=1022:149c,10de:1e89,10de:10f8,10de:1ad8,10de:1ad9"
    "efifb:off"
  ];

  # filesystem

  ## root
  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    options = [ "defaults" "size=8G" "mode=755" ];
  };

  ## boot
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/709E-6BDD";
    fsType = "vfat";
  };

  ## persist
  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/d4787e30-13de-4d09-98a2-291d79b9dd02";
    fsType = "btrfs";
    options = [ "subvol=nix" "noatime" ] ++ btrfsOptions;
  };

  fileSystems."/etc" = {
    device = "/dev/disk/by-uuid/d4787e30-13de-4d09-98a2-291d79b9dd02";
    fsType = "btrfs";
    options = [ "subvol=etc" ] ++ btrfsOptions ++ btrfsRWOnly;
  };

  fileSystems."/var/log" = {
    device = "/dev/disk/by-uuid/d4787e30-13de-4d09-98a2-291d79b9dd02";
    fsType = "btrfs";
    options = [ "subvol=log" ] ++ btrfsOptions ++ btrfsRWOnly;
  };

  fileSystems."/var/lib" = {
    device = "/dev/disk/by-uuid/d4787e30-13de-4d09-98a2-291d79b9dd02";
    fsType = "btrfs";
    options = [ "subvol=lib" ] ++ btrfsOptions;
  };

  ## home
  fileSystems."/root" = {
    device = "/dev/disk/by-uuid/d4787e30-13de-4d09-98a2-291d79b9dd02";
    fsType = "btrfs";
    options = [ "subvol=root" ] ++ btrfsOptions ++ btrfsRWOnly;
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/d4787e30-13de-4d09-98a2-291d79b9dd02";
    fsType = "btrfs";
    options = [ "subvol=home" ] ++ btrfsOptions ++ btrfsRWOnly;
  };

  ## workaround (TODO)
  fileSystems."/etc/executable" = {
    device = "/dev/disk/by-uuid/d4787e30-13de-4d09-98a2-291d79b9dd02";
    fsType = "btrfs";
    options = [ "subvol=executable" ] ++ btrfsOptions;
  };

  fileSystems."/etc/nixos" = {
    device = "/etc/executable/etc/nixos";
    options = [ "bind" ];
  };

  ## rust
  fileSystems."/home/nyarla/.cargo" = {
    device = "/etc/executable/cargo";
    options = [ "bind" ];
  };
  fileSystems."/home/nyarla/.rustup" = {
    device = "/etc/executable/rustup";
    options = [ "bind" ];
  };

  ## perl
  fileSystems."/home/nyarla/.local/share/perl" = {
    device = "/etc/executable/local/share/perl";
    options = [ "bind" ];
  };

  ## npm
  fileSystems."/home/nyarla/.npm" = {
    device = "/etc/executable/npm";
    options = [ "bind" ];
  };

  fileSystems."/home/nyarla/.local/share/npm" = {
    device = "/etc/executable/local/share/npm";
    options = [ "bind" ];
  };

  ## waydroid
  fileSystems."/home/nyarla/.local/share/waydroid" = {
    device = "/etc/executable/local/share/waydroid";
    options = [ "bind" ];
  };

  ## env
  fileSystems."/media/data/executable" = {
    device = "/dev/disk/by-uuid/f2b34caa-5fe5-4cdb-9f13-5c20706c9d04";
    options = [ "subvol=executable" ] ++ btrfsOptions;
  };

  fileSystems."/media/data/sources" = {
    device = "/dev/disk/by-uuid/f2b34caa-5fe5-4cdb-9f13-5c20706c9d04";
    options = [ "subvol=sources" ] ++ btrfsOptions ++ btrfsRWOnly;
  };

  ## backup
  fileSystems."/backup/Archives" = {
    device = "/home/nyarla/Archives";
    options = [ "bind" ];
  };

  fileSystems."/backup/Calibre" = {
    device = "/home/nyarla/Calibre";
    options = [ "bind" ];
  };

  fileSystems."/backup/Development" = {
    device = "/home/nyarla/Development";
    options = [ "bind" ];
  };

  fileSystems."/backup/Music" = {
    device = "/home/nyarla/Music";
    options = [ "bind" ];
  };

  fileSystems."/backup/Photo" = {
    device = "/home/nyarla/Photo";
    options = [ "bind" ];
  };

  fileSystems."/backup/Documents" = {
    device = "/home/nyarla/Documents";
    options = [ "bind" ];
  };

  fileSystems."/backup/NixOS" = {
    device = "/etc/executable/etc/nixos";
    options = [ "bind" ];
  };

  fileSystems."/backup/Executable" = {
    device = "/media/data/executable";
    options = [ "bind" ];
  };

  fileSystems."/backup/Sources" = {
    device = "/media/data/sources";
    options = [ "bind" ];
  };

  services.btrfs.autoScrub.enable = true;
  services.btrfs.autoScrub.fileSystems = [
    "/etc"
    "/etc/executable"
    "/home"
    "/media/data/executable"
    "/media/data/sources"
    "/nix"
    "/root"
    "/var/lib"
    "/var/log"
  ];

  services.snapper.configs = let
    snap = path: {
      SUBVOLUME = path;
      ALLOW_USERS = [ "nyarla" ];
      TIMELINE_CREATE = true;
      TIMELINE_CLEANUP = true;
      TIMETINE_MIN_AGE = 1800;
      TIMELINE_LIMIT_HOURLY = 6;
      TIMELIME_DAILY = 7;
      TIMELINE_WEEKLY = 2;
      TIMELINE_MONTHLY = 1;
      TIMELINE_YEARLY = 1;
    };
  in {
    etc = snap "/etc";
    exe = snap "/etc/executable";
    home = snap "/home";
    varlib = snap "/var/lib";
    root = snap "/root";
    executable = snap "/media/data/executable";
    sources = snap "/media/data/sources";
  };

  swapDevices = [ ];

  # Hardware
  # --------

  # cpu
  powerManagement.cpuFreqGovernor = "performance";
  boot.blacklistedKernelModules = [ "acpi-cpufreq" ];

  # firmware
  hardware.enableRedistributableFirmware = true;

  # Network
  # -------

  # avahi
  services.avahi.allowInterfaces = [ "wlp5s0" ];

  # samba
  services.samba = {
    enable = true;
    enableNmbd = true;
    enableWinbindd = true;
    securityType = "user";
    # package = pkgs.samba4Full;
    extraConfig = ''
      workgroup = WORKGROUP
      server string = nixos
      netbios name = nixos
      security = user
      use sendfile = yes
      hosts allow = 192.168.240.0/24 192.168.122.0/24 localhost
      hosts deny = 0.0.0.0/0
      guest account = nobody
      map to guest = bad user
    '';
    shares = {
      Downloads = {
        "path" = "/home/nyarla/Downloads/KVM";
        "browseable" = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force group" = "users";
        "force user" = "nyarla";
        "guest ok" = "no";
        "read only" = "no";
      };

      Music = {
        "path" = "/home/nyarla/Music";
        "browseable" = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force group" = "users";
        "force user" = "nyarla";
        "guest ok" = "no";
        "read only" = "yes";
      };

      eBooks = {
        "path" = "/home/nyarla/Calibre";
        "browseable" = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force group" = "users";
        "force user" = "nyarla";
        "guest ok" = "no";
        "read only" = "yes";
      };

      DAW = {
        "path" = "/media/data/sources/DAW";
        "browseable" = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force group" = "users";
        "force user" = "nyarla";
        "guest ok" = "no";
        "read only" = "no";
      };
    };
  };

  # Services
  # --------

  # systemd
  systemd.extraConfig = ''
    DefaultTimeoutStartSec=90s
    DefaultTimeoutStopSec=90s
  '';

  # Xorg
  services.picom.backend = "glx";
  services.xserver.serverLayoutSection = ''
    Option "BlankTime"    "0"
    Option "StandbyTime"  "1"
    Option "SuspendTime"  "1"
    Option "OffTime"      "1"
  '';
  services.xserver.xrandrHeads = [{
    output = "HDMI-0";
    monitorConfig = ''
      Option "DPMS" "true"
    '';
  }];

  # backup
  systemd.user.services.backup = {
    enable = true;
    description = "Automatic backup by restic and rclone";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = toString (pkgs.writeShellScript "backup.sh" ''
        set -euo pipefail

        export PATH=${lib.makeBinPath (with pkgs; [ restic-run ])}:$PATH

        cd /backup
        restic-backup .

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
      Unit = "backup.service";
    };
  };

  # ClamAV
  services.clamav.daemon.settings = {
    ExcludePath = [
      "^/bin"
      "^/boot"
      "^/dev"
      "^/home/nyarla/ClamAV"
      "^/lost+found"
      "^/nix"
      "^/proc"
      "^/sys"
      ".snapshots/[0-9]+"
    ];
    MaxThreads = 30;
  };

  systemd.user.services.clamav-scan = {
    enable = true;
    description = "Full Virus Scan by ClamAV";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = toString (pkgs.writeShellScript "clamav-scan.sh" ''
        set -euo pipefail

        export PATH=${lib.makeBinPath (with pkgs; [ clamav ])}:$PATH

        clamdscan -l /home/nyarla/ClamAV/scan.log -i -m --fdpass / || true

        exit 0
      '');
    };
  };

  systemd.user.timers.clamav-scan = {
    enable = true;
    description = "Full Virus Scan by ClamAV";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 03:00:00";
      RandomizedDelaySec = "5m";
      Persistent = true;
    };
  };

  # VM

  ## Win10
  environment.etc."executable/etc/libvirt/hooks/qemu.d/Win10/prepare/begin/hugepage.sh".source =
    toString kvmHugePageSetupScript;
  environment.etc."executable/etc/libvirt/hooks/qemu.d/Win10/release/end/hugepage.sh".source =
    toString kvmHugePageShutdownScript;

  environment.etc."executable/etc/libvirt/hooks/qemu.d/Win10/prepare/begin/vfio.sh".source =
    toString kvmVFIOSetupScript;
  environment.etc."executable/etc/libvirt/hooks/qemu.d/Win10/release/end/vfio.sh".source =
    toString kvmVFIOShutdownScript;

  nixpkgs.config.permittedInsecurePackages = [ "electron-19.0.7" ];
}
