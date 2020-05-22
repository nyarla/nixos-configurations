{ config, pkgs, ... }:
{
  boot.blacklistedKernelModules = [
    "nouveau"
  ];

  hardware.cpu.intel.updateMicrocode = true;

  hardware.bumblebee = {
    enable = true;
    driver = "nvidia";
    group = "video";
    pmMethod = "bbswitch";
  };

  nixpkgs.config.packageOverrides = super: rec {
    linuxPackages_4_19 = super.linuxPackages_4_19.extend (self: base: {
      nvidia_x11 = base.nvidia_x11_beta;
    });

    bumblebee = (super.bumblebee.override { nvidia_x11 = linuxPackages_4_19.nvidia_x11; }).overrideAttrs (old: rec {
      postInstall = old.postInstall + ''
        cat <<EOF >>$out/etc/bumblebee/xorg.conf.nvidia
        
        Section "Screen"
          Identifier "Default Screen"
          Device "DiscreteNvidia"
        EndSection
        EOF
      '';
    });
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = [ pkgs.libGL_driver config.boot.kernelPackages.nvidia_x11.out ];
  };

  services.xserver.useGlamor = true;
  services.xserver.videoDrivers = [ "i915" ];
}
