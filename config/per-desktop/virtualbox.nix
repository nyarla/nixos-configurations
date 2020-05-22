{ config, pkgs, ... }:
{
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;
  virtualisation.virtualbox.host.enableHardening = false;

  boot.blacklistedKernelModules = [
    "kvm_intel"
    "kvm"
    "kvmgt"
  ];

  boot.extraModprobeConfig = ''
    install kvm_intel ${pkgs.coreutils}/bin/true
    install kvm ${pkgs.coreutils}/bin/true
  '';
}
