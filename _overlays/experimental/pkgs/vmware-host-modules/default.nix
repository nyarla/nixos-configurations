{ stdenv, fetchurl, kernel, requireFile }:
let
  message = ''
    this package is reuqired these files:
      - vmci.tar
      - vsock.tar
  '';
  vmci-src = requireFile {
    name = "vmci.tar";
    sha256 = "1jr8j9iqwj0rmjhiqn80g3cpfaass7wfn57y2y1jxrkaadv76mbk";
    message = message;
  };
  vsock-src = requireFile {
    name = "vsock.tar";
    sha256 = "046vkhpzvslfi5335g01rgyr8zc824svq51zzmby583cvp4771jm";
    message = message;
  };
  host-src = fetchurl {
    url =
      "https://codeload.github.com/mkubecek/vmware-host-modules/tar.gz/p15.5.0-k5.3";
    sha256 = "0rg8x9gamx9bn3fb28r1bdrvx1x3n82iw12a9bfysvwkq011c9yr";
  };
in stdenv.mkDerivation rec {
  name = "vmware-host-modules-${version}";
  version = "15.5.0";
  srcs = [ vmci-src vsock-src host-src ];

  hardeningDisable = [ "fortify" "pic" "stackprotector" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  patches = [ ./vmware-host-modules.patch ];

  unpackPhase = ''
    mkdir -p tmp
    tar -C tmp -zxf ${host-src}
    tar -C tmp -xf  ${vmci-src}
    tar -C tmp -xf  ${vsock-src}

    cp -R tmp/vmware-host-*/vmmon-only ./
    cp -R tmp/vmware-host-*/vmnet-only ./
    cp -R tmp/vmci-only  ./
    cp -R tmp/vsock-only ./
    chmod +w -R tmp
    rm -rf tmp
  '';

  buildPhase = ''
    mkdir -p $out
    for mod in vmmon vmnet vmci vsock; do
      cd "$mod"-only;
      sed -i 's|EXTRA_CFLAGS|ccflags-y|g' Makefile.kernel
      make -C "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" M=$(pwd) SRCROOT=$(pwd) VM_KBUILD=1 modules
      cd ../
    done
  '';

  installPhase = ''
    mkdir -p $out/lib/modules/${kernel.modDirVersion}/vmware
    cp *-only/*.ko $out/lib/modules/${kernel.modDirVersion}/vmware
  '';
}
