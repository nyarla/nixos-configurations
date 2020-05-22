{ config, pkgs, ... }:
let
  vmware-host-modules = pkgs.callPackage (import ./pkgs/vmware-host-modules/default.nix) {
    kernel = config.boot.kernelPackages.kernel;
  };
in
{
  boot.extraModulePackages = [
    vmware-host-modules
  ];

  boot.kernelModules = [
    "vmmon"
    "vmnet"
    "vmci"
    "vsock"
  ];

  boot.blacklistedKernelModules = [
    "kvm"
    "kvm_intel"
    "kvmgt"
  ];
}
