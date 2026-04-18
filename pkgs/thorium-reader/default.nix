{
  appimageTools,
  fetchurl,
}:
appimageTools.wrapType2 rec {
  pname = "thorium-reader";
  version = "3.4.0";
  src = fetchurl {
    url = "https://github.com/edrlab/thorium-reader/releases/download/v${version}/Thorium-${version}.AppImage";
    hash = "sha256-wMdfEwgRj/ggTvwhYt+B93LrkeD4bmBliWY1ZV10qaA=";
  };
}
