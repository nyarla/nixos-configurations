{ pkgs, lib, ... }:
let
  gpuIds = lib.concatStringsSep "," [
    # RX 9070
    "1002:7550"
    "1002:ab40"
  ];
  usbId = "1022:149c";
  ids = lib.concatStringsSep "," [
    gpuIds
    usbId
  ];
in
{
  # libvirt-related packages
  programs.virt-manager.enable = true;
  environment.systemPackages = with pkgs; [
    looking-glass-client
    remmina
    spice
    spice-gtk
    virt-manager
    virt-viewer
    virtiofsd
  ];

  # vfio kernel settings
  boot.kernelParams = [
    "iommu=pt"
    "kvm.ignore_msrs=1"
  ];

  boot.extraModprobeConfig = ''
    options vfio_pci ids=${ids} disable_vga=1
  '';

  # libvirtd configurations
  virtualisation.libvirtd = {
    enable = true;
    hooks.qemu =
      let
        PATH = lib.makeBinPath (
          with pkgs;
          [
            libvirt
            kmod
            systemd
          ]
        );

        loadVFIO =
          let
            gpuId = "0000:0d:00.0";
          in
          pkgs.writeShellScript "start.sh" ''
            set -x
            export PATH=${PATH}:$PATH

            echo "Unbind GPU from amdgpu driver..."
            if ! (echo "${gpuId}" | tee /sys/bus/pci/drivers/amdgpu/unbind) ; then
              echo "cannot unbind ${gpuId}"
              exit 1
            fi

            echo "Wait for unbinding..."
            while test -e /sys/bus/pci/drivers/amdgpu/${gpuId}; do
              sleep 1
            done

            echo "Resize to resource2..."
            echo 3 | tee /sys/bus/pci/devices/${gpuId}/resource2_resize
            sleep 3

            echo "Unload amdgpu kernel module..."
            if ! modprobe -r amdgpu ; then
              echo "failed to unload amdgpu. restoring..."
              echo ${gpuId} | tee /sys/bus/pci/drivers/amdgpu/bind
              exit 1
            fi

            systemctl stop amdgpu-kernel-modules.service

            if [[ "$(lsmod | grep amdgpu)" != "" ]]; then
              echo "amdgpu is loaded yet"
              exit 1
            fi

            modprobe vfio_pci
            modprobe vfio
            modprobe vfio_iommu_type1

            virsh nodedev-detach pci_0000_0d_00_0
            virsh nodedev-detach pci_0000_0d_00_1
            virsh nodedev-detach pci_0000_0f_00_3

            set +x
          '';

        unloadVFIO = pkgs.writeShellScript "stop.sh" ''
          set -x

          export PATH=${PATH}:$PATH

          virsh nodedev-reattach pci_0000_0d_00_0
          virsh nodedev-reattach pci_0000_0d_00_1
          virsh nodedev-reattach pci_0000_0f_00_3

          modprobe -r vfio_pci
          modprobe -r vfio_iommu_type1
          modprobe -r vfio

          sleep 2

          set +x
        '';

        allocHugePage =
          let
            memSize = "65536";
          in
          pkgs.writeShellScript "alloc.sh" ''
            set -xeuo pipefail

            export PATH=${pkgs.gawk}/bin:$PATH

            MEMORY=${memSize}
            HUGEPAGES="$(($MEMORY / $(( $(grep Hugepagesize /proc/meminfo | awk '{print $2}') / 1024))))"

            echo $HUGEPAGES > /proc/sys/vm/nr_hugepages
            ALLOC_PAGES=$(cat /proc/sys/vm/nr_hugepages)

            TRIES=0
            while (( $ALLOC_PAGES != $HUGEPAGES && $TRIES < 100 )) ; do
              echo 3 > /proc/sys/vm/drop_caches
              echo 1 > /proc/sys/vm/compact_memory

              echo $HUGEPAGES > /proc/sys/vm/nr_hugepages
              ALLOC_PAGES=$(cat /proc/sys/vm/nr_hugepages)

              let TRIES+=1
            done

            if test "$ALLOC_PAGES" -ne "$HUGEPAGES"; then
              echo 0 > /proc/sys/vm/nr_hugepages
              echo 3 > /proc/sys/vm/drop_caches
              exit 1
            fi

            set +x
            exit 0
          '';

        deallocHugePage = pkgs.writeShellScript "dealloc.sh" ''
          echo 0 > /proc/sys/vm/nr_hugepages
        '';

        qemuHooks = pkgs.runCommand "qemu-hooks" { } ''
          mkdir -p $out/prepare/begin
          mkdir -p $out/release/end

          cp ${allocHugePage} $out/prepare/begin/00_alloc_hugepage.sh
          cp ${loadVFIO} $out/prepare/begin/01_load_vfio.sh

          cp ${unloadVFIO} $out/release/end/00_unload_vfio.sh
          cp ${deallocHugePage} $out/release/end/01_dealloc_hugepage.sh
        '';
      in
      {
        DAW = toString qemuHooks;
        VR = toString qemuHooks;
      };

    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;

      verbatimConfig = ''
        user = "root"
        group = "libvirtd"

        cgroup_device_acl = [
          "/dev/null",
          "/dev/full",
          "/dev/zero",
          "/dev/random",
          "/dev/urandom",
          "/dev/ptmx",
          "/dev/kvm",
          "/dev/dri/card1",
          "/dev/dri/renderD128"
        ]
      '';
    };
    extraConfig = ''
      unix_sock_group = "libvirtd"
      unix_sock_ro_perms = "0770"
      unix_sock_rw_perms = "0770"
      auth_unix_ro = "none"
      auth_unix_rw = "none"
      clear_emulator_capabilities = 0
    '';

    onBoot = "ignore";
    onShutdown = "shutdown";
  };

  systemd.tmpfiles.rules =
    let
      qemuScript =
        let
          script = pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/PassthroughPOST/VFIO-Tools/0410193a205c5f150b8dfb411e83f8c42c511a2e/libvirt_hooks/qemu";
            sha256 = "0fphif8r5llflaq5fc7bxswb4xjmjppycnqkjnw8l76ak8yrv2hc";
          };
        in
        pkgs.writeShellScript "qemu-hook.sh" ''
          ${builtins.readFile (toString script)}
        '';
    in
    [
      "L+ /var/lib/libvirt/hooks/qemu - - - - ${qemuScript}"
      "f /dev/shm/looking-glass 0660 nyarla kvm -"
    ];
}
