self: super:
let
  require = path: args: super.callPackage (import path) args;
  # nixpkgs-pin-wine-staging = import
  #   (builtins.fetchTarball {
  #     url = "https://github.com/NixOS/nixpkgs/archive/1b89bffcf47dc1e271bea128635e33efd9481b93.tar.gz";
  #     sha256 = "1l02i0hlqbzwxr7sm0y92nw4498xpdvg0ll7i4ladkpm866r4pwj";
  #   }) { };
in
{
  bitwig-studio3 = super.bitwig-studio3.overrideAttrs (old: rec {
    name = "bitwig-studio3-${version}";
    version = "3.2";
    src = super.fetchurl {
      url = "https://downloads.bitwig.com/stable/3.2/bitwig-studio-3.2.deb";
      sha256 = "1gvj5bdavmy8486rm2hin65b37irncn7n0n1wk1fyivc3vz7mwsh";
    };
  });

  lv2 = super.lv2.overrideAttrs (old: rec {
    version = "1.16.0";
    src = super.fetchurl {
      url = "https://lv2plug.in/spec/${old.pname}-${version}.tar.bz2";
      sha256 = "1ppippbpdpv13ibs06b0bixnazwfhiw0d0ja6hx42jnkgdyp5hyy";
    };
  });

  # wineWowPackages = nixpkgs-pin-wine-staging.wineWowPackages;
}
