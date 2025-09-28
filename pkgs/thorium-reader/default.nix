{
  appimageTools,
  fetchurl,
}:
appimageTools.wrapType2 rec {
  pname = "thorium-reader";
  version = "3.2.2";
  src = fetchurl {
    url = "https://github.com/edrlab/thorium-reader/releases/download/v${version}/Thorium-${version}.AppImage";
    hash = "sha256-BkczBJ27k0ZDd0ch77Q6tYRGYSLWs/cryH3dENDUBp0=";
  };
}
