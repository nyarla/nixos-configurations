{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config.boot.kernelPackages.nvidiaPackages) mkDriver;
  vgpuVersion = "525.125.03";

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

  patched-nvidia = nvidia.overrideAttrs (old: rec {
    name = "NVIDIA-Linux-x86_64-525.125.06-merged-vgpu-kvm-patched";
    version = vgpuVersion;

    src = pkgs.fetchurl {
      url = "file:///home/nyarla/Applications/Environment/vGPU/NVIDIA-Linux-x86_64-525.125.06-merged-vgpu-kvm-patched.run";
      sha256 = "1a7dlniimkkbjwzc9bjm6gk2wh42nbgfdnncjgnxxvarf56p1q97";
    };

    postPatch = ''
      sed -i 's|/usr/share/nvidia/vgpu|/etc/nvidia-vgpu-xxxxx|' nvidia-vgpud
      substituteInPlace sriov-manage \
        --replace lspci ${pkgs.pciutils}/bin/lspci \
        --replace setpci ${pkgs.pciutils}/bin/setpci
    '';

    preFixup = ''
      for i in libnvidia-vgpu.so.${vgpuVersion} libnvidia-vgxcfg.so.${vgpuVersion}; do
        install -Dm755 "$i" "$out/lib/$i"
      done

      patchelf --set-rpath ${pkgs.stdenv.cc.cc.lib}/lib $out/lib/libnvidia-vgpu.so.${vgpuVersion}
      install -Dm644 vgpuConfig.xml $out/vgpuConfig.xml

      for i in nvidia-vgpud nvidia-vgpu-mgr; do
        install -Dm755 "$i" "$bin/bin/$i"
        # stdenv.cc.cc.lib is for libstdc++.so needed by nvidia-vgpud
        patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
          --set-rpath $out/lib "$bin/bin/$i"
      done
      install -Dm755 sriov-manage $bin/bin/sriov-manage
    '';

    nativeBuildInputs = (with pkgs; [ coreutils ]) ++ old.nativeBuildInputs;
  });

  patched-nvidia-32 = patched-nvidia.lib32;
in
{
  boot = {
    blacklistedKernelModules = [ "i2c_nvidia_gpu" ];
    kernelModules = [ "nvidia-vgpu-vfio" ];
    kernelParams = [
      "nvidia.vgpukvm=1"
      "nvidia.cudahost=1"
      "nvidia.kmalimit=6144"
    ];
  };

  hardware.nvidia = {
    modesetting.enable = true;
    package = patched-nvidia;
    open = false;
    forceFullCompositionPipeline = true;
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    setLdLibraryPath = true;
    package = patched-nvidia;
    package32 = patched-nvidia-32;
  };

  services.udev.extraRules = ''
    ACTION=="change", ENV{MDEV_STATE}=="registered", TEST=="/etc/mdevctl.d/$kernel", RUN+="${pkgs.stdenv.shell} -c '{ ${pkgs.mdevctl}/bin/mdevctl start-parent-mdevs %k 2>&3 | logger -t mdevctl; } 3>&1 1>&2 | logger -t mdevctl -p 2'"
    ACTION=="add", TEST=="/etc/mdevctl.d/$kernel", RUN+="${pkgs.stdenv.shell} -c '{ ${pkgs.mdevctl}/bin/mdevctl start-parent-mdevs %k 2>&3 | logger -t mdevctl; } 3>&1 1>&2 | logger -t mdevctl -p 2'"
  '';

  systemd.tmpfiles.rules = [ "f /dev/shm/looking-glass 0600 nyarla kvm -" ];
  systemd.services.nvidia-vgpud = {
    description = "NVIDIA vGPU Daemon";
    wants = [ "syslog.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "forking";
      ExecStart = "${lib.getBin config.hardware.nvidia.package}/bin/nvidia-vgpud";
      ExecStopPost = "${pkgs.coreutils}/bin/rm -rf /var/run/nvidia-vgpud";
      Environment = [
        "LD_PRELOAD=${pkgs.vgpu_unlock-rs}/lib/libvgpu_unlock_rs.so"
        "__RM_NO_VERSION_CHECK=1"
      ];
    };
  };

  systemd.services.nvidia-vgpu-mgr = {
    description = "NVIDIA vGPU Manager Daemon";
    wants = [ "syslog.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "forking";
      KillMode = "process";
      ExecStart = "${lib.getBin config.hardware.nvidia.package}/bin/nvidia-vgpu-mgr";
      ExecStopPost = "${pkgs.coreutils}/bin/rm -rf /var/run/nvidia-vgpu-mgr";
      Environment = [
        "LD_PRELOAD=${pkgs.vgpu_unlock-rs}/lib/libvgpu_unlock_rs.so"
        "__RM_NO_VERSION_CHECK=1"
      ];
    };
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.deviceSection = ''
    Option "Coolbits" "28"
    Option "AllowEmptyInitialConfiguration"
  '';

  environment = {
    etc = {
      "glvnd/egl_vendor.d".source = "${config.hardware.nvidia.package}/share/glvnd/egl_vendor.d/";
      "gbm/nvidia-drm_gbm.so".source = "${config.hardware.nvidia.package}/lib/libnvidia-allocator.so";
      "nvidia-vgpu-xxxxx/vgpuConfig.xml".source = "${config.hardware.nvidia.package}/vgpuConfig.xml";

      "vgpu_unlock/profile_override.toml".text = ''
        [profile.nvidia-256]
        num_displays = 1
        display_width = 1920
        display_height = 1080
        max_pixels = 2073600
        cuda_enabled = 1
      '';
    };

    systemPackages = with pkgs; [
      mdevctl
      (cuda-shell.override {
        nvidia_x11 = patched-nvidia;
        cudaPackages = pkgs.cudaPackages_12_1;
      })
      #(tabby.override { nvidia_x11 = nvidia; })
    ];
  };

  programs.nix-ld.libraries = [
    patched-nvidia.out
    patched-nvidia.bin
  ];

  virtualisation.docker.enableNvidia = true;
}
