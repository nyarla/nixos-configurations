{ config, pkgs, ... }:
let
  gui = if config.services.xserver.enable then
    (with pkgs; [ virt-manager remmina ])
  else
    [ ];
in {
  environment.systemPackages = gui;
  services.dbus.packages = gui;

  boot.kernelModules = [ "amd_iommnu" "pcie_aspm" "iommu" "vfio_pci" ];
  boot.kernelParams =
    [ "amd_iommu=on" "pcie_aspm=off" "iommu=pt" "vfio-pci.ids=1022:149c" ];

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
    '';
    onBoot = "ignore";
    onShutdown = "suspend";
    qemuVerbatimConfig = ''
      user = "nyarla"
      group = "libvirtd"
    '';
  };
}
