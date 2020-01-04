self: super: let
  require = path: args: super.callPackage (import path) args ;
in { 
# compton = super.compton.overrideAttrs (old: rec {
#   src = super.fetchFromGitHub {
#     owner  = "yshui";
#     repo   = "picom";
#     rev    = "v7.4";
#     sha256 = "11mrfiivwa1lba1ipck0l6q86ngwv1p0rs2dln05mk1904qbnj9h";
#     fetchSubmodules = true;
#   }; 
# });

  fcitx-configtool = super.fcitx-configtool.overrideAttrs (old: rec {
    preConfigure = ''
      sed -ie '/^set(exec_prefix /d' CMakeLists.txt
      substituteInPlace config.h.in \
        --subst-var-by exec_prefix ${super.fcitx}
    '';
  });

  firefox-bin-unwrapped = super.firefox-bin-unwrapped.override {
    systemLocale = "ja";
  };
  
  google-cloud-sdk = super.google-cloud-sdk.overrideAttrs (old: rec {
    version = "245.0.0";
    src = super.fetchurl {
      url     = "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-245.0.0-linux-x86_64.tar.gz";
      sha256  = "bdc66eea38a78ae5b00c7caaa4848965ef63bce73d4374fc806f94ddfd34f10f";
    };
  });

  libvirt = super.libvirt.override {
    enableXen  = false;
    enableCeph = false;
  };
}
  
