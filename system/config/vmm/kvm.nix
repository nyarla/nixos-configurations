{ pkgs, lib, ... }:
let
  gpuIds = lib.concatStringsSep "," [
    "10de:10f8"
    "10de:1ad8"
    "10de:1ad9"
    "10de:1e89"
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
  ];

  # vfio kernel settings
  boot.kernelModules = [
    "pcie_aspm"
    "iommu"
  ];

  boot.kernelParams = [
    "iommu=pt"
    "kvm.ignore_msrs=1"
    "pcie_aspm=off"
  ];

  boot.extraModprobeConfig = ''
    options vfio_pci ids=${ids}
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
          ]
        );

        loadVFIO = pkgs.writeShellScript "start.sh" ''
          set -xeuo pipefail
          export PATH=${PATH}:$PATH

          modprobe -r nvidia_uvm
          modprobe -r nvidia

          modprobe vfio_pci
          modprobe vfio
          modprobe vfio_iommu_type1

          virsh nodedev-detach pci_0000_0b_00_3
          virsh nodedev-detach pci_0000_0b_00_2
          virsh nodedev-detach pci_0000_0b_00_1
          virsh nodedev-detach pci_0000_0b_00_0

          virsh nodedev-detach pci_0000_0d_00_3

          set +x
        '';

        unloadVFIO = pkgs.writeShellScript "stop.sh" ''
          set -x

          export PATH=${PATH}:$PATH

          virsh nodedev-reattach pci_0000_0b_00_3
          virsh nodedev-reattach pci_0000_0b_00_2
          virsh nodedev-reattach pci_0000_0b_00_1
          virsh nodedev-reattach pci_0000_0b_00_0

          virsh nodedev-reattach pci_0000_0d_00_3

          modprobe -r vfio_pci
          modprobe -r vfio_iommu_type1
          modprobe -r vfio

          set +x
        '';

        allocHugePage = pkgs.writeShellScript "alloc.sh" ''
          set -xeuo pipefail

          export PATH=${pkgs.gawk}/bin:$PATH

          MEMORY=65536
          HUGEPAGES="$(($MEMORY / $(( $(grep Hugepagesize /proc/meminfo | awk '{print $2}') / 1024))))"

          echo $HUGEPAGES > /proc/sys/vm/nr_hugepages
          ALLOC_PAGES=$(cat /proc/sys/vm/nr_hugepages)

          TRIES=0
          while (( $ALLOC_PAGES != $HUGEPAGES && $TRIES < 100 )) ; do
            echo 1 > /proc/sys/vm/compact_memory

            echo $HUGEPAGES > /proc/sys/vm/nr_hugepages
            ALLOC_PAGES=$(cat /proc/sys/vm/nr_hugepages)

            let TRIES+=1
          done

          if test "$ALLOC_PAGES" -ne "$HUGEPAGES"; then
            echo 0 >/proc/sys/vm/nr_hugepages
            exit 1
          fi

          set +x
          exit 0
        '';

        deallocHugePage = pkgs.writeShellScript "dealloc.sh" ''
          echo 0 >/proc/sys/vm/nr_hugepages
        '';

        qemuHooks = pkgs.runCommand "qemu-hooks" { } ''
          mkdir -p $out/prepare/begin
          mkdir -p $out/release/end

          cp ${loadVFIO} $out/prepare/begin/00_load_vfio.sh
          cp ${unloadVFIO} $out/release/end/00_unload_vfio.sh

          cp ${allocHugePage} $out/prepare/begin/01_alloc_hugepage.sh
          cp ${deallocHugePage} $out/release/end/01_dealloc_hugepage.sh
        '';
      in
      {
        DAW = toString qemuHooks;
        Development = toString qemuHooks;
      };

    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      ovmf.enable = true;
      ovmf.packages = [ pkgs.OVMFFull.fd ];

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
      "f /dev/shm/looking-glass 0660 user kvm -"
    ];

  services.samba = {
    enable = true;
    enableNmbd = true;
    enableWinbindd = true;
    securityType = "user";
    extraConfig = ''
      workgroup = WORKGROUP
      server string = nixos
      netbios name = nixos
      security = user
      use sendfile = yes
      hosts allow = 192.168.122.0/24 localhost
      hosts deny = 0.0.0.0/0
      guest account = nobody
      map to guest = bad user
    '';

    shares = {
      Downloads = {
        path = "/persist/home/nyarla/Downloads/KVM";
        browsable = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force group" = "users";
        "force user" = "nyarla";
        "guest ok" = "false";
        "read only" = "yes";
      };

      DAW = {
        path = "/persist/home/nyarla/Sources/DAW";
        browsable = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force group" = "users";
        "force user" = "nyarla";
        "guest ok" = "false";
        "read only" = "no";
      };
    };
  };
}
