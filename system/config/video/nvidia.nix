{ config, pkgs, ... }:
let
  inherit (config.boot.kernelPackages.nvidiaPackages) mkDriver;

  nvidia = mkDriver {
    version = "525.125.06";
    sha256_64bit = "sha256-tSdWifSoM8N6UHcXrI8O4vH1zSt+I2/6cKrY37dFW50=";
    sha256_aarch64 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    openSha256 = "sha256-exFI3jzs5r+vXGd5adDqJuntONMmRUvMegPydPz5IJE=";

    settingsVersion = "525.116.04";
    settingsSha256 = "sha256-qNjfsT9NGV151EHnG4fgBonVFSKc4yFEVomtXg9uYD4=";

    persistencedVersion = "525.116.04";
    persistencedSha256 = "sha256-ci86XGlno6DbHw6rkVSzBpopaapfJvk0+lHcR4LDq50=";
  };

  nvidia32 = nvidia.lib32;
in {
  boot.blacklistedKernelModules = [ "i2c_nvidia_gpu" ];

  services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.deviceSection = ''
    Option "Coolbits" "28"
    Option "AllowEmptyInitialConfiguration"
  '';
  services.xserver.screenSection = ''
    Option "TripleBuffer" "on"
    Option "MetaModes" "1920x1080 { ForceFullCompositionPipeline=On }"
  '';

  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.package = nvidia;
  hardware.nvidia.open = false;
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    setLdLibraryPath = true;
    package = nvidia;
    package32 = nvidia32;
    extraPackages = with pkgs; [ nvidia-vaapi-driver mesa.drivers ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      nvidia-vaapi-driver
      mesa.drivers
    ];
  };

  environment.etc."glvnd/egl_vendor.d".source =
    "${config.hardware.nvidia.package}/share/glvnd/egl_vendor.d/";
  environment.etc."gbm/nvidia-drm_gbm.so".source =
    "${config.hardware.nvidia.package}/lib/libnvidia-allocator.so";

  environment.systemPackages = with pkgs; [
    (cuda-shell.override {
      nvidia_x11 = nvidia;
      cudaPackages = pkgs.cudaPackages_12_1;
    })
    (tabby.override { nvidia_x11 = nvidia; })
  ];

  virtualisation.docker.enableNvidia = true;
}
