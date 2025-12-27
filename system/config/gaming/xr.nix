{ pkgs, ... }:
{
  nixpkgs.xr.enable = true;

  # for ntsync
  boot.kernelModules = [
    "ntsync"
  ];

  # wivrn
  services.wivrn = {
    package = pkgs.wivrn-stable;
    enable = true;
    autoStart = true;
    defaultRuntime = true;
    highPriority = true;
    monadoEnvironment = {
      DRI_PRIME = "1002:7550!";
      MESA_VK_DEVICE_SELECT = "1002:7550";
      AMD_VULKAN_ICD = "RADV";
      VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";

      WMR_HANDTRACKING = "1";
    };
    config = {
      enable = true;
      json = {
        bitrate = 25000000;
        scale = 1;
        tcp-only = true;
        encoders = [
          {
            encoder = "vaapi";
            codec = "h265";
          }
        ];
      };
    };
  };

  environment.systemPackages = with pkgs; [
    wlx-overlay-s
  ];
}
