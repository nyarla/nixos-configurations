{
  sources,

  appimageTools,
  fetchurl,
  libgpg-error,
}:

let
  pname = "immersed";
  version = "latest";

  src = fetchurl {
    inherit (sources.immersed) url hash;
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
      libsm
      libx11
      zlib
    ];
}
