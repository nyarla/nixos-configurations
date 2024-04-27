{
  pkgs,
  name,
  vm,
  allocationSize,
  ...
}:
let
  startupScript = pkgs.writeShellScript "startup.sh" ''
    set -x

    HUGEPAGE=${toString allocationSize}
    echo $HUGEPAGE > /proc/sys/vm/nr_hugepages
    ALLOC_PAGES=$(cat /proc/sys/vm/nr_hugepages)

    TRIES=0
    while (( $ALLOC_PAGES != $HUGEPAGE && $TRIES < 1000 )); do
      echo 1 > /proc/sys/vm/compact_memory
      echo $HUGEPAGE > /proc/sys/vm/nr_hugepages
      ALLOC_PAGES=$(cat /proc/sys/vm/nr_hugepages)

      let TRIES+=1
    done

    if test $HUGEPAGE != $ALLOC_PAGES ; then
      echo "failed to enable hugepage"
      echo 0 > /proc/sys/vm/nr_hugepages
      exit 1
    fi
  '';
  shutdownScript = pkgs.writeShellScript "shutdown.sh" ''
    echo 0 > /proc/sys/vm/nr_hugepages
  '';
in
{
  systemd.tmpfiles.rules = [
    "L+ /etc/executable/etc/libvirt/hooks/qemu.d/${vm}/prepare/begin/${name}.sh - - - - ${startupScript}"
    "L+ /etc/executable/etc/libvirt/hooks/qemu.d/${vm}/release/end/${name}.sh - - - - ${shutdownScript}"
  ];
}
