self: super: let
  require = path: args: super.callPackage (import path) args ;
in { 
  bitwig-studio3 = super.bitwig-studio3.overrideAttrs (old: rec {
    name = "bitwig-studio3-${version}";
    version = "3.1.3";
    src = super.fetchurl {
      url = "https://downloads.bitwig.com/stable/3.1.3/bitwig-studio-3.1.3.deb";
      sha256 = "11z5flmp55ywgxyccj3pzhijhaggi42i2pvacg88kcpj0cin57vl";
    }; 
  });
}
  
