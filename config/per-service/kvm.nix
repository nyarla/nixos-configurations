{ config, pkgs, ... }:
let
  gui = if config.services.xserver.enable then
    (with pkgs; [ virt-manager ])
  else
    [ ];
in {
  environment.systemPackages = gui;
  services.dbus.packages = gui;

  virtualisation.libvirtd = {
    enable = true;
    qemuPackage = pkgs.qemu_kvm;
    qemuRunAsRoot = true;
    extraConfig = ''
      unix_sock_group = "libvirtd"
      unix_sock_ro_perms = "0770"
      unix_sock_rw_perms = "0770"
      auth_unix_ro = "none"
      uth_unix_rw = "none"
    '';
    onBoot = "start";
    onShutdown = "suspend";
  };
}
