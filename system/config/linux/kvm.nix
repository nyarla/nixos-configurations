{ config, pkgs, lib, ... }:
let
  gui = if config.services.xserver.enable then
    (with pkgs; [ virt-manager ])
  else
    [ ];

  qemu_hook = pkgs.runCommand "qemu.sh" { } ''
    mkdir -p $out/bin
    cp ${
      pkgs.fetchurl {
        url =
          "https://raw.githubusercontent.com/PassthroughPOST/VFIO-Tools/master/libvirt_hooks/qemu";
        sha256 = "sha256-DIqdPZrKHIq4lRNb5u+VVXayuO7rMFewoo7SkpGL8Do=";
      }
    } $out/bin/qemu

    sed -i 's|#!/usr/bin/env bash|#!${pkgs.bash}/bin/bash|' $out/bin/qemu
    chmod +x $out/bin/qemu
  '';

  hasNvidia = lib.hasPrefix (lib.findFirst (x: lib.hasPrefix x "nvidia") ""
    config.services.xserver.videoDrivers) "nvidia";

in {
  environment.systemPackages = gui ++ [ pkgs.bash ];

  boot.kernelModules = [ "pcie_aspm" "iommu" ];
  boot.kernelParams = [ "iommu=pt" "kvm.ignore_msrs=1" "pcie_aspm=off" ];

  system.activationScripts.libvirt-hooks.text = ''
    ln -Tfs /etc/libvirt/hooks /var/lib/libvirt/hooks
  '';

  environment.etc."libvirt/hooks/qemu" = {
    source = "${qemu_hook}/bin/qemu";
    mode = "0755";
  };

  virtualisation.libvirtd = {
    enable = true;
    qemu.package = pkgs.qemu_kvm;
    qemu.runAsRoot = true;
    extraConfig = ''
      unix_sock_group = "libvirtd"
      unix_sock_ro_perms = "0770"
      unix_sock_rw_perms = "0770"
      auth_unix_ro = "none"
      auth_unix_rw = "none"
      clear_emulator_capabilities = 0
    '';
    onBoot = "start";
    onShutdown = "shutdown";
    qemu.verbatimConfig = ''
      user = "root"
      group = "libvirtd"

      cgroup_device_acl = [
      ${lib.optionalString hasNvidia ''
        "/dev/nvidia-modeset",
        "/dev/nvidia-uvm",
        "/dev/nvidia-uvm-tools",
        "/dev/nvidia0",
        "/dev/nvidia1",
        "/dev/nvidia2",
        "/dev/nvidia3",
        "/dev/nvidiactl",
        "/dev/dri/card0",
        "/dev/dri/renderD128",
      ''}

        "/dev/null",
        "/dev/full",
        "/dev/zero",
        "/dev/random",
        "/dev/urandom",
        "/dev/ptmx",
        "/dev/kvm"
      ]
    '';
  };
}
