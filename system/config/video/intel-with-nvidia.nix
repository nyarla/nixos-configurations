{ pkgs, config, ... }:
let
  nvidia = config.boot.kernelPackages.nvidiaPackages.latest;
in
{
  boot = {
    blacklistedKernelModules = [
      "i2c_nvidia_gpu"
      "nouveau"
      "nvidia"
      "nvidia_drm"
      "nvidia_modeset"
      "nvidia_uvm"
    ];
    initrd.kernelModules = [ "i915" ];
  };

  hardware = {
    intel-gpu-tools.enable = true;
    nvidia = {
      modesetting.enable = false;
      package = nvidia;
    };

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
      extraPackages32 = with pkgs.pkgsi686Linux; [
        intel-media-driver
        intel-vaapi-driver
        libvdpau-va-gl
        mesa.drivers
        libGL
      ];
    };
  };

  environment.variables = {
    VDPAU_DRIVER = "va_gl";
  };

  services.xserver.videoDrivers = [
    "i915"
    "nvidia"
  ];

  environment.systemPackages = with pkgs; [
    (nvtopPackages.full)
    (cuda-shell.override {
      nvidia_x11 = nvidia;
      cudaPackages = pkgs.cudaPackages_12_1;
    })
  ];

  virtualisation.docker.enableNvidia = true;
  services.ollama.acceleration = "cuda";
}
