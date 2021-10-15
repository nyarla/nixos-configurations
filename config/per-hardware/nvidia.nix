{ pkgs, config, ... }: {
  boot.blacklistedKernelModules = [ "i2c_nvidia_gpu" ];

  services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.screenSection = ''
    Option "MetaModes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
    Option "AllowIndirectGLXProtocol" "off"
    Option "TripleBuffer" "on"
  '';

  hardware.nvidia.modesetting.enable = true;
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    setLdLibraryPath = true;
    extraPackages = with pkgs; [ libglvnd libvdpau-va-gl ];
  };

  environment.etc."glvnd/egl_vendor.d".source =
    "${config.boot.kernelPackages.nvidia_x11}/share/glvnd/egl_vendor.d/";
}
