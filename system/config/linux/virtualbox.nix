{ pkgs, ... }: {
  boot.kernelModules = [ "kvm" "kvm-amd" ];
  boot.kernelParams = [ "kvm.ignore_msrs=1" ];

  virtualisation.virtualbox.host = {
    enable = true;
    enableExtensionPack = false;
    package = pkgs.virtualbox-kvm;
  };
}
