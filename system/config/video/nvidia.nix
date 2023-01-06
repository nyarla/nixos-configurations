{ config, pkgs, ... }:
let
  nvidia = config.boot.kernelPackages.nvidiaPackages.production;
  nvidia32 = nvidia.lib32;
in {
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
  hardware.nvidia.package = nvidia;
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    setLdLibraryPath = true;
    package = nvidia;
    package32 = nvidia32;
  };

  environment.etc."glvnd/egl_vendor.d".source =
    "${config.hardware.nvidia.package}/share/glvnd/egl_vendor.d/";
  environment.etc."gbm/nvidia-drm_gbm.so".source =
    "${config.hardware.nvidia.package}/lib/libnvidia-allocator.so";

  environment.systemPackages = with pkgs;
    [ (cuda-shell.override { linuxPackages = config.boot.kernelPackages; }) ];

  virtualisation.podman.enableNvidia = true;
}
