{
  appimageTools,
  fetchurl,
  libgpg-error,
}:

let
  pname = "immersed";
  version = "latest";

  src = fetchurl {
    url = "https://static.immersed.com/dl/Immersed-x86_64.AppImage";
    sha256 = "0jpf0vvs708z7q98rh4my9y6xyvq6167vlqb2p7vzywaymkj9dqr";
  };

  src' = appimageTools.extract {
    inherit pname version;
    inherit src;

    postExtract = ''
      cp ${libgpg-error}/lib/* $out/usr/lib/
    '';
  };
in
appimageTools.wrapAppImage {
  inherit pname version;
  src = src';
  extraPkgs =
    pkgs: with pkgs; [
      e2fsprogs
      fontconfig
      freetype
      fribidi
      harfbuzz
      libGL
      libdrm
      libgbm
      libgpg-error
      libp11
      libthai
      libva
      pipewire
      wayland
      xorg.libSM
      xorg.libX11
      zlib
    ];
}
