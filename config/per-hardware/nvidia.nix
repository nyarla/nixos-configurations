{ pkgs, config, ... }: {
  boot.blacklistedKernelModules = [ "i2c_nvidia_gpu" ];

  services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.deviceSection = ''
    Option "Coolbits" "28"
    Option "AllowEmptyInitialConfiguration"
  '';
  services.xserver.screenSection = ''
    Option "MetaModes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
    Option "AllowIndirectGLXProtocol" "off"
    Option "TripleBuffer" "on"
  '';

  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidia_x11;
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    setLdLibraryPath = true;
    package = config.boot.kernelPackages.nvidia_x11;
    package32 = config.boot.kernelPackages.nvidia_x11_legacy390;
    extraPackages = with pkgs; [ libglvnd nvidia-vaapi-driver ];
  };

  environment.etc."glvnd/egl_vendor.d".source =
    "${config.boot.kernelPackages.nvidia_x11}/share/glvnd/egl_vendor.d/";
  environment.etc."gbm/nvidia-drm_gbm.so".source =
    "${config.boot.kernelPackages.nvidia_x11}/lib/libnvidia-allocator.so";
}
