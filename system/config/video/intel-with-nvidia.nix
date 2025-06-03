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
      "nvidia_uvm"
      "nvidia_drm"
      "nvidia_modeset"
    ];
    initrd.kernelModules = [ "i915" ];
    kernelParams = [
      "i915.enable_guc=3"
    ];
  };

  hardware = {
    i2c.enable = true;
    intel-gpu-tools.enable = true;
    nvidia = {
      modesetting.enable = false;
      package = nvidia;
      open = true;
      nvidiaSettings = true;
      nvidiaPersistenced = false;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
    };

    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        intel-media-driver
        libvdpau-va-gl
      ];
      extraPackages32 = with pkgs.driversi686Linux; [
        intel-media-driver
        libvdpau-va-gl
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
      cudaPackages = pkgs.cudaPackages_12_8;
    })
    nvidia-maximize
    ddcui
    ddcutil
  ];

  # hardware.nvidia-container-toolkit.enable = true;
  services.ollama.acceleration = "cuda";
}
