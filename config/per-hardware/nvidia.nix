{ pkgs, config, ... }: {
  boot.blacklistedKernelModules = [ "i2c_nvidia_gpu" ];

  services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.screenSection = ''
    Option "metamodes" "nvidia-auto-select +0+0 { ForceFullCompositionPipeline = On }"
    Option "AllowIndirectGLXProtocol" "off"
    Option "TripleBuffer" "on"
  '';

  hardware.nvidia.modesetting.enable = true;

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    setLdLibraryPath = true;
  };
}
