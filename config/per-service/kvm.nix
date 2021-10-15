{ config, pkgs, ... }:
let
  gui = if config.services.xserver.enable then
    (with pkgs; [ virt-manager remmina ])
  else
    [ ];

  qemu_hook = pkgs.runCommand "qemu.sh" { } ''
    mkdir -p $out/bin
    cp ${
      pkgs.fetchurl {
        url =
          "https://raw.githubusercontent.com/PassthroughPOST/VFIO-Tools/master/libvirt_hooks/qemu";
        sha256 = "155dz6535lxxy1pc8yq8kbmc80fh6x35459n7ppf3zwmcdb63rg6";
      }
    } $out/bin/qemu

    sed -i 's|#!/bin/bash|#!/run/current-system/sw/bin/bash|' $out/bin/qemu
    chmod +x $out/bin/qemu
  '';
in {
  environment.systemPackages = gui ++ [ pkgs.bash ];
  services.dbus.packages = gui ++ [ pkgs.bash ];

  boot.kernelModules = [ "amd_iommnu" "pcie_aspm" "iommu" "vfio_pci" ];
  boot.kernelParams = [
    "kvm.ignore_msrs=1"
    "amd_iommu=on"
    "pcie_aspm=off"
    "iommu=pt"
    "vfio-pci.ids=1022:149c"
  ];

  system.activationScripts.libvirt-hooks.text = ''
    ln -Tfs /etc/libvirt/hooks /var/lib/libvirt/hooks
  '';

  environment.etc."libvirt/hooks/qemu" = {
    source = "${qemu_hook}/bin/qemu";
    mode = "0755";
  };

  virtualisation.libvirtd = {
    enable = true;
    qemuPackage = pkgs.qemu_kvm;
    qemuRunAsRoot = true;
    extraConfig = ''
      unix_sock_group = "libvirtd"
      unix_sock_ro_perms = "0770"
      unix_sock_rw_perms = "0770"
      auth_unix_ro = "none"
      auth_unix_rw = "none"
      clear_emulator_capabilities = 0
    '';
    onBoot = "ignore";
    onShutdown = "shutdown";
    qemuVerbatimConfig = ''
      user = "nyarla"
      group = "libvirtd"

      cgroup_device_acl = [
        "/dev/null",
        "/dev/full",
        "/dev/zero",
        "/dev/random",
        "/dev/urandom",
        "/dev/ptmx",
        "/dev/kvm",

        "/dev/nvidia-modeset",
        "/dev/nvidia-uvm",
        "/dev/nvidia-uvm-tools",
        "/dev/nvidia0",
        "/dev/nvidia1",
        "/dev/nvidia2",
        "/dev/nvidia3",
        "/dev/nvidiactl",
        "/dev/dri/card0",
        "/dev/dri/renderD128"
      ]
    '';
  };
}
