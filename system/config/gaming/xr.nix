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
        bitrate = 4096000000;
        scale = 1;
        encoders = [
          {
            encoder = "vaapi";
            codec = "h265";
            width = 1.0;
            height = 1.0;
            offset_x = 0.0;
            offset_y = 0.0;
          }
        ];
      };
    };
  };

  environment.systemPackages = with pkgs; [
    wlx-overlay-s
  ];
}
