{ pkgs, ... }:
{
  nixpkgs.xr.enable = true;

  # wivrn
  services.wivrn = {
    package = pkgs.wivrn-stable;
    enable = true;
    autoStart = true;
    defaultRuntime = true;
    monadoEnvironment = {
      STEAMVR_LH_ENABLE = "1";
      WMR_HANDTRACKING = "0";
      XRT_COMPOSITOR_COMPUTE = "1";
      XRT_COMPOSITOR_FORCE_GPU_INDEX = "1";
      DRI_PRIME = "1";
    };
    config = {
      enable = true;
      json = {
        bitrate = 1000000000;
        encoders = [
          {
            encoder = "vaapi";
            codec = "av1";
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
