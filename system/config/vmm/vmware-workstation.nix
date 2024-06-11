{ pkgs, ... }:
{
  boot.blacklistedKernelModules = [
    "kvm"
    "kvm_amd"
    "kvm_intel"
  ];
  virtualisation.vmware.host = {
    enable = true;
    package = pkgs.vmware-workstation.override { enableMacOSGuests = true; };
    extraPackages = with pkgs; [
      ntfs3g
      exfat
    ];
  };
}
