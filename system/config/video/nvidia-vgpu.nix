{ config, pkgs, lib, ... }:
let
  patched-nvidia = let vgpuVersion = "525.85.07";
  in config.boot.kernelPackages.nvidiaPackages.production.overrideAttrs
  (old: rec {
    name = "NVIDIA-Linux-x86_64-5.25.85-vgpu-kvm-patched";
    version = vgpuVersion;

    src = pkgs.requireFile {
      name = "NVIDIA-Linux-x86_64-525.85.05-merged-vgpu-kvm-patched.run";
      message = "this config requires patched nvidia driver";
      sha256 = "0lksankwl13x4bc25iyh9znpr14y0jk763pzab0s12sz6yndzhqr";
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
in {
  boot.blacklistedKernelModules = [ "i2c_nvidia_gpu" ];
  boot.kernelModules = [ "nvidia-vgpu-vfio" ];
  boot.kernelParams = [ "nvidia.cudahost=1" "nvidia.kmalimit=6144" ];

  services.xserver.videoDrivers = [ "nvidia" ];
  # services.xserver.deviceSection = ''
  #   Option "Coolbits" "28"
  #   Option "AllowEmptyInitialConfiguration"
  # '';
  # services.xserver.screenSection = ''
  #   Option "MetaModes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
  #   Option "AllowIndirectGLXProtocol" "off"
  #   Option "TripleBuffer" "on"
  # '';

  hardware.nvidia.modesetting.enable = false;
  hardware.nvidia.package = patched-nvidia;
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    setLdLibraryPath = true;
    package = patched-nvidia;
    package32 = patched-nvidia.lib32;
    extraPackages = with pkgs; [ nvidia-vaapi-driver ];
    extraPackages32 = with pkgs.pkgsi686Linux; [ nvidia-vaapi-driver ];
  };

  environment.etc."glvnd/egl_vendor.d".source =
    "${config.hardware.nvidia.package}/share/glvnd/egl_vendor.d/";
  environment.etc."gbm/nvidia-drm_gbm.so".source =
    "${config.hardware.nvidia.package}/lib/libnvidia-allocator.so";

  environment.systemPackages = with pkgs; [
    (cuda-shell.override { linuxPackages = config.boot.kernelPackages; })
    mdevctl
    looking-glass-client
  ];

  services.udev.extraRules = ''
    ACTION=="change", ENV{MDEV_STATE}=="registered", TEST=="/etc/mdevctl.d/$kernel", RUN+="${pkgs.stdenv.shell} -c '{ ${pkgs.mdevctl}/bin/mdevctl start-parent-mdevs %k 2>&3 | logger -t mdevctl; } 3>&1 1>&2 | logger -t mdevctl -p 2'"
    ACTION=="add", TEST=="/etc/mdevctl.d/$kernel", RUN+="${pkgs.stdenv.shell} -c '{ ${pkgs.mdevctl}/bin/mdevctl start-parent-mdevs %k 2>&3 | logger -t mdevctl; } 3>&1 1>&2 | logger -t mdevctl -p 2'"
  '';

  systemd.tmpfiles.rules = [ "f /dev/shm/looking-glass 0600 nyarla kvm -" ];

  virtualisation.podman.enableNvidia = true;

  systemd.services.nvidia-vgpud = {
    description = "NVIDIA vGPU Daemon";
    wants = [ "syslog.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "forking";
      ExecStart =
        "${lib.getBin config.hardware.nvidia.package}/bin/nvidia-vgpud";
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
      ExecStart =
        "${lib.getBin config.hardware.nvidia.package}/bin/nvidia-vgpu-mgr";
      ExecStopPost = "${pkgs.coreutils}/bin/rm -rf /var/run/nvidia-vgpu-mgr";
      Environment = [
        "LD_PRELOAD=${pkgs.vgpu_unlock-rs}/lib/libvgpu_unlock_rs.so"
        "__RM_NO_VERSION_CHECK=1"
      ];
    };
  };

  environment.etc."nvidia-vgpu-xxxxx/vgpuConfig.xml".source =
    config.hardware.nvidia.package + /vgpuConfig.xml;

  environment.etc."vgpu_unlock/profile_override.toml".text = ''
    [profile.nvidia-257]
    num_displays = 1
    display_width = 1920
    display_height = 1080
    max_pixels = 2073600
    cuda_enabled = 1
  '';
}
