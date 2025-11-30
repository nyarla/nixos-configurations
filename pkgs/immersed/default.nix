{
  appimageTools,
  fetchurl,
  lib,
  libgpg-error,
}:

let
  pname = "immersed";
  version = "latest";

  src = fetchurl {
    url = "https://static.immersed.com/dl/Immersed-x86_64.AppImage";
    sha256 = "1md4bvqja15h7plgp5ym4nb8fzd19555aknayz5xwqghcwr58gl5";
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
