{ pkgs, config, ... }:
{
  boot = {
    initrd.kernelModules = [ "i915" ];
    kernelParams = [
      "i915.enable_guc=3"
    ];
  };

  hardware = {
    i2c.enable = true;
    intel-gpu-tools.enable = true;
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        amdvlk
        intel-media-driver
        libvdpau-va-gl
        rocmPackages.clr.icd
      ];
      extraPackages32 = with pkgs.driversi686Linux; [
        amdvlk
        intel-media-driver
        libvdpau-va-gl
      ];
    };
  };

  systemd.tmpfiles.rules =
    let
      rocmEnv = pkgs.symlinkJoin {
        name = "rocm-combined";
        paths = with pkgs.rocmPackages; [
          clr
          hipblas
          rocblas
        ];
      };
    in
    [
      "L+ /opt/rocm - - - - ${rocmEnv}"
    ];

  environment.variables = {
    VDPAU_DRIVER = "va_gl";
  };

  services.xserver = {
    videoDrivers = [
      "i915"
      "amdgpu"
    ];
  };

  environment.systemPackages =
    with pkgs;
    [
      clinfo
      ddcui
      ddcutil
      igsc
      nvtopPackages.full
    ]
    ++ (with pkgs.rocmPackages; [
      amdsmi
      rocm-smi
    ]);
}
