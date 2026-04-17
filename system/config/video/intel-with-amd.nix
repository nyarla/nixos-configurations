{ pkgs, ... }:
{
  boot = {
    initrd.kernelModules = [
      "i915"
      "amdgpu"
    ];
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
        intel-media-driver
        libvdpau-va-gl
      ];
      extraPackages32 = with pkgs.driversi686Linux; [
        intel-media-driver
        libvdpau-va-gl
      ];
    };

    amdgpu = {
      overdrive = {
        enable = true;
        ppfeaturemask = "0xffffffff";
      };
      opencl.enable = true;
    };
  };

  services.lact = {
    enable = true;
    settings = {
      version = 5;

      daemon = {
        log_level = "info";
        admin_group = "wheel";
        disable_clocks_cleanup = false;
      };

      apply_settings_timer = 5;
      current_profile = null;
      auto_switch_profiles = true;

      gpus = {
        "1002:7550-148C:2436-0000:0d:00.0" = {
          performance_level = "manual";
          power_profile_mode_index = 2; # Power saving
        };
      };

      profiles = {
        VR = {
          gpus = {
            "1002:7550-148C:2436-0000:0d:00.0" = {
              performance_level = "manual";
              power_profile_mode_index = 4; # VR
            };
          };
          rule = {
            type = "process";
            filter.name = "wivrn-server";
          };
        };
      };
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
      "intel"
      "amdgpu"
    ];
  };

  environment.systemPackages =
    let
      amd-run = pkgs.amd-run.override { gpuId = "1002:7550"; };
      unityhub-amd = pkgs.unityhub-amd.override { inherit amd-run; };
    in
    [
      amd-run
      unityhub-amd
      unityhub-amd.unity-run
    ]
    ++ (with pkgs; [
      clinfo
      ddcui
      ddcutil
      igsc
      (nvtopPackages.full.override {
        amd = true;
        intel = true;
      })
    ])
    ++ (with pkgs.rocmPackages; [
      amdsmi
      rocm-smi
    ]);

  services.ollama = {
    package = pkgs.ollama-rocm;
    environmentVariables = {
      "ROCM_PATH" = "/opt/rocm";
      "HIP_VISIBLE_DEVICES" = "0";
      "HSA_OVERRIDE_GFX_VERSION" = "12.0.1";
    };
  };
}
