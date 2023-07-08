{ pkgs, lib, name, vm, ... }:
let
  startupScript = pkgs.writeShellScript "startup.sh" ''
    set -x
    export PATH=${lib.makeBinPath (with pkgs; [ kmod procps libvirt ])}:$PATH

    # shutdown display manager
    if systemctl is-active display-manager ; then
      systemctl stop display-manager
    fi

    while systemctl is-active --quiet display-manager; do
      sleep 1
    done

    # unbind vtcon
    for i in $(seq 0 16); do
      if test "$(grep -c 'frame buffer' "/sys/class/vtconsole/vtcon''${i}/name")" == 1; then
        echo 0 > /sys/class/vtconsole/vtcon''${i}/bind
        echo "''${i}" >> /tmp/vfio-bound-consoles
      fi
    done

    # unload gpu drivers
    echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind
    modprobe -r nvidia_uvm
    modprobe -r nvidia_drm
    modprobe -r nvidia_modeset
    modprobe -r nvidia
    modprobe -r drm_kms_helper
    modprobe -r drm

    # load vfio drivers
    modprobe vfio
    modprobe vfio_pci
    modprobe vfio_iommu_type1
  '';

  shutdownScript = pkgs.writeShellScript "shutdown.sh" ''
    set -x
    export PATH=${lib.makeBinPath (with pkgs; [ kmod procps libvirt ])}:$PATH

    # unload vfio kernel modules
    modprobe -r vfio_pci
    modprobe -r vfio_iommu_type1
    modprobe -r vfio

    # load gpu drivers
    modprobe drm
    modprobe drm_kms_helper
    modprobe nvidia
    modprobe nvidia_modeset
    modprobe nvidia_drm
    modprobe nvidia_uvm

    # start display manager
    systemctl start display-manager

    # attach vtcon
    input="/tmp/vfio-bound-consoles"
    while read -r idx ; do
      if -x "/sys/class/vtconsole/vtcon''${idx}"; then
        if test "$(grep -c 'frame buffer' "/sys/class/vtconsole/vtcon''${idx}/name")" = 1; then
          echo 1 > /sys/class/vtconsole/vtcon''${idx}/bind
        fi
      fi
    done < "$input"
  '';
in {
  systemd.tmpfiles.rules = [
    "L+ /etc/executable/etc/libvirt/hooks/qemu.d/${vm}/prepare/begin/${name}.sh - - - - ${startupScript}"
    "L+ /etc/executable/etc/libvirt/hooks/qemu.d/${vm}/release/end/${name}.sh - - - - ${shutdownScript}"
  ];
}
