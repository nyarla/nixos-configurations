{ pkgs, ... }:
# nvidia = config.boot.kernelPackages.nvidiaPackages.latest;
# nvidia32 = nvidia.lib32;
{
  boot = {
    blacklistedKernelModules = [
      # "i2c_nvidia_gpu"
      # "nouveau"
    ];

    initrd.kernelModules = [ "i915" ];

    kernelModules = [
      # this modules requires by CUDA on Wayland environment
      # "nvidia_uvm"
    ];
  };

  hardware = {
    intel-gpu-tools.enable = true;
    # nvidia = {
    #   modesetting.enable = false;
    #   package = nvidia;
    #   open = true;
    #   forceFullCompositionPipeline = true;
    # };

    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      setLdLibraryPath = true;
      extraPackages = with pkgs; [
        intel-media-driver
        intel-vaapi-driver
        libvdpau-va-gl
        mesa.drivers
        libGL
      ];
      # ++ [ nvidia ];
      extraPackages32 = with pkgs.pkgsi686Linux; [
        intel-media-driver
        intel-vaapi-driver
        libvdpau-va-gl
        mesa.drivers
        libGL
      ];
      # ++ [ nvidia32 ];
    };
  };

  environment = {
    variables = {
      VDPAU_DRIVER = "va_gl";
    };

    # systemPackages = [
    #   (pkgs.cuda-shell.override {
    #     nvidia_x11 = nvidia;
    #     cudaPackages = pkgs.cudaPackages_12_1;
    #   })
    #   pkgs.nvtopPackages.nvidia
    # ];
  };

  services.xserver.videoDrivers = [
    "i915"
    # "nvidia"
  ];

  environment.systemPackages = with pkgs; [ (nvtopPackages.full) ];
}
