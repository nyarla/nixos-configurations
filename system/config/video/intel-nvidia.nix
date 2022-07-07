{ config, pkgs, ... }: {
  boot.blacklistedKernelModules = [ "nouveau" ];

  hardware.bumblebee = {
    enable = true;
    driver = "nvidia";
    group = "video";
    pmMethod = "bbswitch";
  };

  nixpkgs.config.packageOverrides = super: {
    bumblebee = super.bumblebee.overrideAttrs (old: rec {
      postInstall = old.postInstall + ''
        cat <<EOF >$out/etc/bumblebee/xorg.conf.nvidia

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
    extraPackages = (with pkgs; [ libGL_dri ])
      ++ [ config.boot.kernelPackages.nvidia_x11.out ];
  };

  services.xserver.useGlamor = true;
  services.xserver.videoDriver = [ "i915" ];
}
