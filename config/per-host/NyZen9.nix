{ pkgs, ... }:
let apps = with pkgs; [ syncthing mosh ];
in {
  imports = [
    ../per-service/avahi.nix
    ../per-service/network-manager.nix
    ../per-service/docker.nix
    ../per-service/firewall.nix
    ../per-service/kvm.nix
    ../per-service/printer.nix
    ../per-service/tailscale.nix
  ];

  environment.systemPackages = apps;

  # avahi
  services.avahi.interfaces = [ "wlan0" ];

  # kvm
  boot.kernelModules = [ "kvm-amd" "amd_iommu" ];
  boot.kernelParams = [
    "amd_iommnu=on"
    "vfio-pci.ids=1022:149c,10de:1e89,10de:10f8,10de:1ad8,10de:1ad9"
  ];

  # environment.etc."libvirt/hooks/qemu.d/DTM/prepare/begin/cryptsetup.sh" = {
  #   text = ''
  #     #!${pkgs.stdenv.shell}

  #     set -x

  #     if test ! -e /dev/mapper/Win10Pro ; then
  #       ${pkgs.cryptsetup}/bin/cryptsetup \
  #         --key-file /home/nyarla/local/data/keys/Win10Pro.key \
  #         luksOpen /dev/disk/by-uuid/72185511-1e14-40c0-8c3c-07e43594d8f5 Win10Pro
  #     fi
  #   '';
  #   mode = "0755";
  # };

  # environment.etc."libvirt/hooks/qemu.d/DTM/prepare/begin/hugepage.sh" = {
  #   text = ''
  #     #!${pkgs.stdenv.shell}

  #     set -x

  #     echo 35200 > /proc/sys/vm/nr_hugepages
  #     if test 35200 != $(cat /proc/sys/vm/nr_hugepages) ; then
  #       echo "faild to set hugepages"
  #       echo 0 > /proc/sys/vm/nr_hugepages
  #       exit 1
  #     fi
  #   '';
  #   mode = "0755";
  # };

  # environment.etc."libvirt/hooks/qemu.d/DTM/prepare/begin/vfio.sh" = {
  #   text = ''
  #     #!${pkgs.stdenv.shell}

  #     set -x

  #     systemctl stop display-manager.service

  #     ${pkgs.kmod}/bin/modprobe -r nvidia_drm nvidia_modeset nvidia_uvm nvidia

  #     echo 0 > /sys/class/vtconsole/vtcon0/bind
  #     echo 0 > /sys/class/vtconsole/vtcon1/bind

  #     echo "efi-framebuffer.0" > /sys/bus/platform/drivers/efi-framebuffer/unbind

  #     sleep 2

  #     ${pkgs.kmod}/bin/modprobe vfio
  #     ${pkgs.kmod}/bin/modprobe vfio_iommnu_type1
  #     ${pkgs.kmod}/bin/modprobe vfio_pci

  #     ${pkgs.libvirt}/bin/virsh nodedev-detach pci_0000_07_00_0
  #     ${pkgs.libvirt}/bin/virsh nodedev-detach pci_0000_07_00_1
  #     ${pkgs.libvirt}/bin/virsh nodedev-detach pci_0000_07_00_2
  #     ${pkgs.libvirt}/bin/virsh nodedev-detach pci_0000_07_00_3
  #   '';
  #   mode = "0755";
  # };

  # environment.etc."libvirt/hooks/qemu.d/DTM/release/end/cryptsetup.sh" = {
  #   text = ''
  #     #!${pkgs.stdenv.shell}

  #     set -x

  #     if test -e /dev/mapper/Win10Pro ; then
  #       ${pkgs.cryptsetup}/bin/cryptsetup luksClose Win10Pro
  #     fi
  #   '';
  #   mode = "0755";
  # };

  # environment.etc."libvirt/hooks/qemu.d/DTM/release/end/hugepage.sh" = {
  #   text = ''
  #     #!${pkgs.stdenv.shell}
  #     echo 0 > /proc/sys/vm/nr_hugepages
  #   '';
  #   mode = "0755";
  # };

  # environment.etc."libvirt/hooks/qemu.d/DTM/release/end/vfio.sh" = {
  #   text = ''
  #     #!${pkgs.stdenv.shell}
  #     set -x

  #     ${pkgs.libvirt}/bin/virsh nodedev-reattach pci_0000_07_00_3
  #     ${pkgs.libvirt}/bin/virsh nodedev-reattach pci_0000_07_00_2
  #     ${pkgs.libvirt}/bin/virsh nodedev-reattach pci_0000_07_00_1
  #     ${pkgs.libvirt}/bin/virsh nodedev-reattach pci_0000_07_00_0

  #     ${pkgs.kmod}/bin/modprobe -r vfio_pci
  #     ${pkgs.kmod}/bin/modprobe -r vfio_iommnu_type1
  #     ${pkgs.kmod}/bin/modprobe -r vfio

  #     echo "efi-framebuffer.0" > /sys/bus/platform/drivers/efi-framebuffer/bind

  #     echo 1 > /sys/class/vtconsole/vtcon0/bind
  #     echo 1 > /sys/class/vtconsole/vtcon1/bind

  #     ${pkgs.kmod}/bin/modprobe nvidia_drm
  #     ${pkgs.kmod}/bin/modprobe nvidia_modeset
  #     ${pkgs.kmod}/bin/modprobe nvidia_uvm
  #     ${pkgs.kmod}/bin/modprobe nvidia

  #     ${pkgs.systemd}/bin/systemctl start display-manager.service
  #   '';

  #   mode = "0755";
  # };

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
      hosts allow = 192.168.254.0/24 localhost
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
    };
  };

  # sshd
  services.openssh = {
    enable = true;
    startWhenNeeded = true;
    permitRootLogin = "no";
    openFirewall = false;
    passwordAuthentication = true;
    kbdInteractiveAuthentication = false;
    listenAddresses = [{
      addr = "0.0.0.0";
      port = 2222;
    }];
  };

  # firewall
  networking.firewall.checkReversePath = "loose";
  networking.firewall.allowPing = true;
  networking.firewall.allowedTCPPorts = [ 139 445 ];
  networking.firewall.allowedUDPPorts = [ 137 138 ];
  networking.firewall.interfaces = {
    "tailscale0" = {
      allowedTCPPorts = [
        # calibre-server
        8085

        # sshd
        2222

        # http
        80
        443

        # mpd
        6600
        9999
      ];
      allowedUDPPortRanges = [{
        from = 60000;
        to = 61000;
      }];
    };

    "wlan0" = {
      allowedTCPPorts = [
        # syncthing
        22000
      ];
      allowedUDPPorts = [
        # service
        22000
        21027

        # scanner
        8610
        8612
      ];
    };
  };

}
