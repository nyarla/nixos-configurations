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
    kernelParams = [ "i915.enable_guc=3" ];
  };

  hardware = {
    intel-gpu-tools.enable = true;
    nvidia = {
      modesetting.enable = false;
      package = nvidia;
    };

    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        intel-media-driver
        intel-vaapi-driver
        libvdpau-va-gl
        mesa.drivers
        libGL
        libglvnd
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [
        intel-media-driver
        intel-vaapi-driver
        libvdpau-va-gl
        mesa.drivers
        libGL
        libglvnd
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
    igsc
    (nvtopPackages.full.override {
      intel = true;
      nvidia = true;
    })
    (cuda-shell.override {
      nvidia_x11 = nvidia;
      cudaPackages = pkgs.cudaPackages_12_1;
    })
  ];

  # hardware.nvidia-container-toolkit.enable = true;
  services.ollama.acceleration = "cuda";
}
